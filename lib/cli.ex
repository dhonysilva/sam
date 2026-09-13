defmodule Sam.CLI do
  def main(arg \\ []) do
    arg
    |> parse_args()
    |> process()
  end

  defp parse_args(arg) do
    arg
    |> OptionParser.parse(strict: [init: :string, commit: :string])
    |> elem(1)
    |> args_to_internal_representation()
  end

  defp args_to_internal_representation(["init", dir]) do
    dir |> Path.expand()
    {:init, dir}
  end

  defp args_to_internal_representation(["init"]) do
    {:ok, dir} = File.cwd()
    {:init, dir}
  end

  defp process({:init, dir}) do
    Sam.Init.init(dir)
  end
end
