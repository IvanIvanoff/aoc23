defmodule DayX do
  def get_input(), do: File.read!("./lib/inputs/dayX") |> Utils.split_lines()

  # Part A
  def run_a() do
    get_input()
  end

  # Part B
  def run_b() do
    get_input()
  end
end
