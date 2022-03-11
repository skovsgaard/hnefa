defmodule Hnefa.Game do
  use GenServer

  alias Hnefa.Helpers.Matrix

  # Public API

  def start_link(_) do
    board = [
      [:barred, :empty, :empty, :black, :black, :black, :black, :black, :empty, :empty, :barred,],
      [:empty, :empty, :empty, :empty, :empty, :black, :empty, :empty, :empty, :empty, :empty,],
      [:empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty,],
      [:black, :empty, :empty, :empty, :empty, :white, :empty, :empty, :empty, :empty, :black,],
      [:black, :empty, :empty, :empty, :white, :white, :white, :empty, :empty, :empty, :black,],
      [:black, :black, :empty, :white, :white, :king, :white, :white, :empty, :black, :black,],
      [:black, :empty, :empty, :empty, :white, :white, :white, :empty, :empty, :empty, :black,],
      [:black, :empty, :empty, :empty, :empty, :white, :empty, :empty, :empty, :empty, :black,],
      [:empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty, :empty,],
      [:empty, :empty, :empty, :empty, :empty, :black, :empty, :empty, :empty, :empty, :empty,],
      [:barred, :empty, :empty, :black, :black, :black, :black, :black, :empty, :empty, :barred,],
    ] |> Matrix.from_list()

    GenServer.start_link(__MODULE__, board, name: __MODULE__)
  end

  def move(:right, x, y), do: GenServer.call(__MODULE__, {:move_right, {x, y}})
  def move(:left, x, y), do: GenServer.call(__MODULE__, {:move_left, {x, y}})
  def move(:up, x, y), do: GenServer.call(__MODULE__, {:move_up, {x, y}})
  def move(:down, x, y), do: GenServer.call(__MODULE__, {:move_down, {x, y}})

  # Callbacks

  def init(board) do
    {:ok, board}
  end

  def handle_call({:move_right, {x, y}}, _from, board) when x < 12 do
    IO.puts("Moving piece: ")
    piece = board[y][x] |> IO.inspect()
    IO.puts("Moving to: ")
    new_position = board[y][x + 1] |> IO.inspect()

    board = put_in(board, piece, :empty) |> put_in([y, x], piece)

    {:reply, :ok, board}
  end
end
