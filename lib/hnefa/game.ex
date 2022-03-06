defmodule Hnefa.Game do
  use GenServer

  def start_link() do
    board = [
      :barred, :empty, :empty, :black, :black, :black, :black, :black, :empty, :empty, :barred,
      :empty, :empty, :empty, :empty, :empty, :black, :empty, :empty, :empty, :empty, :empty,
      :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty,
      :black, :empty, :empty, :empty, :empty, :white, :empty, :empty, :empty, :empty, :black,
      :black, :empty, :empty, :empty, :white, :white, :white, :empty, :empty, :empty, :black,
      :black, :black, :empty, :white, :white, :white, :white, :white, :empty, :black, :black,
      :black, :empty, :empty, :empty, :white, :white, :white, :empty, :empty, :empty, :black,
      :black, :empty, :empty, :empty, :empty, :white, :empty, :empty, :empty, :empty, :black,
      :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty,
      :empty, :empty, :empty, :empty, :empty, :black, :empty, :empty, :empty, :empty, :empty,
      :barred, :empty, :empty, :black, :black, :black, :black, :black, :empty, :empty, :barred,
    ]

    GenServer.start_link(__MODULE__, board)
  end

  def init(board) do
    {:ok, board}
  end

  def handle_call({:move, :right}, _from, board) do
    {:reply, :ok, board}
  end
end
