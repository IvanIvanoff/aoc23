defmodule DayX do
  def get_input(), do: File.read!("./lib/inputs/dayX") |> Utils.split_lines()

  def run_a() do
    get_input()
  end

  def run_b() do
    get_input()
  end
end
