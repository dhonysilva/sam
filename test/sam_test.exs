defmodule SamTest do
  use ExUnit.Case
  doctest Sam

  test "greets the world" do
    assert Sam.hello() == :world
  end
end
