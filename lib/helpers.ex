defmodule Sam.Helpers do
  def sam_path(root_path) do
    root_path
    |> Path.join(".git")
  end
end
