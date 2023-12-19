defmodule Day19 do
  def get_input(), do: File.read!("./lib/inputs/day19") |> parse()

  def run_a() do
    get_input() |> find_accepted()
  end

  def run_b() do
    get_input()
  end

  defp find_accepted(%{workflows: workflows, inputs: inputs}) do
    inputs
    |> Enum.filter(fn input ->
      eval_input(input, "in", workflows)
    end)
    |> Enum.flat_map(&Map.values/1)
    |> Enum.sum()
  end

  defp eval_input(input, current, workflows) do
    case current do
      "A" -> true
      "R" -> false
      _ -> eval_input(input, next_workflow(input, workflows[current]), workflows)
    end
  end

  defp next_workflow(input, workflow) do
    workflow
    |> Enum.reduce_while(nil, fn
      next, _ when is_binary(next) -> {:halt, next}
      {:<, l, r, next}, _ -> if input[l] < r, do: {:halt, next}, else: {:cont, nil}
      {:>, l, r, next}, _ -> if input[l] > r, do: {:halt, next}, else: {:cont, nil}
    end)
  end

  defp parse(input) do
    [workflows, inputs] = String.split(input, "\n\n")

    %{workflows: parse_workflows(workflows), inputs: parse_inputs(inputs)}
  end

  defp parse_workflows(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [name, internal] = String.split(line, ["{", "}"], trim: true)

      {name, parse_internal(internal)}
    end)
    |> Map.new()
  end

  defp parse_inputs(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.trim_leading("{")
      |> String.trim_trailing("}")
      |> parse_internal()
    end)
    |> Enum.map(fn l ->
      Enum.reduce(l, %{}, fn {:=, k, v}, acc -> Map.put(acc, k, v) end)
    end)
  end

  defp parse_internal(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(fn check ->
      case String.split(check, ~r/([><:=])/, include_captures: true) do
        [workflow] -> workflow
        [lhs, ">", rhs, ":", workflow] -> {:>, lhs, String.to_integer(rhs), workflow}
        [lhs, "<", rhs, ":", workflow] -> {:<, lhs, String.to_integer(rhs), workflow}
        [lhs, "=", rhs] -> {:=, lhs, String.to_integer(rhs)}
      end
    end)
  end
end
