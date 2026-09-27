# `sam cat-file` — design doc

## Problem

Objects written by `Sam.Database.write_object/2` are zlib-compressed
(`:zlib.compress/1`) before being saved under `objects/<2-char>/<38-char>`.
Because of that, plain `cat objects/CE/0136...` just dumps compressed
binary — `cat` has no decompression flag. Real git solves this with a
dedicated plumbing command, `git cat-file -p <oid>`, rather than `cat`
itself. This doc designs an equivalent `sam cat-file <oid>` command for
this project.

The design mirrors `git cat-file -p`: find the object file by oid,
zlib-decompress it, strip the `"<type> <size>\0"` header, and print the
raw payload.

This is **documentation only** — none of the code below has been applied
to the project yet.

## `lib/database.ex` changes

Extract the path-building logic currently inline in `write_object/2`
(`lib/database.ex:16`) into a shared private `object_path/2` helper, used
by both `write_object/2` and a new `load/1`:

```elixir
def load(oid) do
  {:ok, dir} = File.cwd()

  dir
  |> object_path(oid)
  |> File.read()
  |> case do
    {:ok, compressed} -> {:ok, :zlib.uncompress(compressed)}
    {:error, reason} -> {:error, reason}
  end
end

defp object_path(root_path, oid) do
  Path.join([db_path(root_path), String.slice(oid, 0..1), String.slice(oid, 2..-1//1)])
end
```

`write_object/2` would then call `object_path(dir, oid)` instead of
duplicating the split logic inline.

## `lib/cli.ex` changes

Add arg parsing for `["cat-file", oid]`, following the same
`.git`-existence check used by `commit` (`lib/cli.ex:25-33`):

```elixir
defp args_to_internal_representation(["cat-file", oid]) do
  if File.exists?(".git") do
    {:cat_file, oid}
  else
    IO.puts(:stderr, "repo not initialized")
    exit(:fatal)
  end
end
```

Add a `process/1` clause that loads the object, strips the header, and
writes the raw content to stdout, or prints a `fatal:` error on failure:

```elixir
defp process({:cat_file, oid}) do
  case Sam.Database.load(oid) do
    {:ok, content} ->
      [_header, data] = :binary.split(content, <<0>>)
      IO.write(data)

    {:error, _reason} ->
      IO.puts(:stderr, "fatal: Not a valid object name #{oid}")
      exit(:fatal)
  end
end
```

## Scope notes

- Takes a full 40-char oid only — no abbreviated/short-hash resolution,
  consistent with how oids are used everywhere else in the codebase
  today.
- No other files need to change.

## Verification (when implemented)

1. `mix compile` — no warnings.
2. In a `sam`-initialized directory with a committed file: run
   `sam cat-file <oid>` and confirm it prints the exact original file
   content, with no `blob <size>\0` header leaking into the output.
3. Run `sam cat-file <bogus-oid>` and confirm it prints a `fatal:` error
   to stderr instead of crashing.
4. If `test/` has existing tests, run `mix test` to confirm no
   regressions.
