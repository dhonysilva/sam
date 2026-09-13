defmodule Sam.Init do
  alias Sam.Helpers

  def init(root_path) do
    root_path
    |> Helpers.sam_path()
    |> make_dirs()
  end

  defp make_dirs(sam_path) do
    if not File.exists?(sam_path) do
      Enum.each(["objects", "refs"], fn dir ->
        case File.mkdir_p(Path.join(sam_path, dir)) do
          :ok ->
            :ok

          {:error, reason} ->
            IO.puts(:stderr, "fatal: #{:file.format_error(reason)}")
            exit(:fatal)
        end
      end)

      IO.puts("Initialized empty sam repository in #{sam_path}")
    end
  end
end
