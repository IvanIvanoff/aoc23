defmodule DayX do
  def get_input(), do: File.read!("./lib/inputs/dayX")

  # Part A
  def run_a(input \\ get_input()) do
    input
    |> Utils.split_lines()
  end

  # Part B

  def run_b(input \\ get_input()) do
    input
    |> Utils.split_lines()
  end
end
