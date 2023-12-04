defmodule Utils do
  def split_lines(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(&(&1 == ""))
  end

  def find_all(_bin, _regex) do
    # TODO
  end
end
