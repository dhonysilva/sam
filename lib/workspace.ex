defmodule Sam.Workspace do
  alias Sam.Helpers

  def list_files do
    list = Path.wildcard("./*")

    Enum.map(list, fn path -> Helpers.ls_r(path) end)
    |> List.flatten()
  end
end
