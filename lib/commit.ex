defmodule Sam.Commit do
  alias Sam.Workspace
  alias Sam.BLOB
  alias Sam.Database

  def commit(_root_path) do
    Workspace.list_files()
    |> Enum.each(fn file ->
      case File.read(file) do
        {:ok, data} ->
          %BLOB{data: data}
          |> Database.store()

        {:error, _} ->
          :noop
      end
    end)
  end
end
