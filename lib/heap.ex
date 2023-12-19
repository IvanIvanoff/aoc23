defmodule Heap do
  def new(), do: :gb_sets.new()

  def add(heap, key, weight) do
    :gb_sets.add({weight, key}, heap)
  end

  def peek_smallest(heap) do
    :gb_sets.smallest(heap)
  end

  def pop_smallest(heap) do
    {weight, key} = :gb_sets.smallest(heap)
    heap = :gb_sets.delete({weight, key}, heap)
    {{key, weight}, heap}
  end
end
