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

  def move(:right, y, x), do: GenServer.call(__MODULE__, {:move_right, {y, x}})
  def move(:left, y, x), do: GenServer.call(__MODULE__, {:move_left, {y, x}})
  def move(:up, y, x), do: GenServer.call(__MODULE__, {:move_up, {y, x}})
  def move(:down, y, x), do: GenServer.call(__MODULE__, {:move_down, {y, x}})

  # Public API (temporary)
  def get_board, do: GenServer.call(__MODULE__, :get_board)

  # Callbacks

  def init(board) do
    {:ok, board}
  end

  def handle_call(:get_board, _, board), do: {:reply, {:ok, board}, board}

  def handle_call({:move_right, {y, x}}, _from, board) when x < 12 do
    IO.puts("Moving piece: ")
    piece = board[y][x] |> IO.inspect()
    IO.puts("Moving to: ")
    new_position = board[y][x + 1] |> IO.inspect()

    if can_move?(piece, new_position) do
      new_board = Map.update!(board, y, fn(row) ->
        Map.update!(row, x, fn(_) -> :empty end)
        |> Map.update!(x + 1, fn(_) -> piece end)
      end)

      {:reply, {:ok, new_board}, new_board}
    else
      {:reply, {:error, :invalid_move}, board}
    end
  end

  # Internal functionality

  defp can_move?(origin, destination) do
    case origin do
      :white ->
        case destination do
          :white -> false
          :king -> false
          :barred -> false
          :black -> true
          _ -> true
        end
      :king ->
        case destination do
          :white -> false
          :king -> false
          :barred -> false
          :black -> true
          _ -> true
        end
      :black ->
        case destination do
          :white -> true
          :king -> true
          :barred -> false
          :black -> false
          _ -> true
        end
      _ -> false
    end
  end
end
