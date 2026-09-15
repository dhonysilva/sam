defmodule Sam.Init do
  alias Sam.Helpers

  def init(root_path) do
    root_path
    |> Helpers.git_path()
    |> make_dirs()
  end

  # Create the subfolders /.git/objects and /.git/refs
  defp make_dirs(git_path) do
    if not File.exists?(git_path) do
      Enum.each(["objects", "refs"], fn dir ->
        case File.mkdir_p(Path.join(git_path, dir)) do
          :ok ->
            :ok

          {:error, reason} ->
            IO.puts(:stderr, "fatal: #{:file.format_error(reason)}")
            exit(:fatal)
        end
      end)

      IO.puts("Initialized empty sam repository in #{git_path}")
    end
  end
end
