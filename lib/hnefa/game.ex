defmodule Hnefa.Game do
  use GenServer

  alias Hnefa.Helpers.Matrix

  # Public API

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
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

  @spec move(:down | :left | :right | :up, integer, integer) :: {:ok, Matrix.t()} | {:error, :invalid_move}
  def move(:right, y, x), do: GenServer.call(__MODULE__, {:move_right, {y, x}})
  def move(:left, y, x), do: GenServer.call(__MODULE__, {:move_left, {y, x}})
  def move(:up, y, x), do: GenServer.call(__MODULE__, {:move_up, {y, x}})
  def move(:down, y, x), do: GenServer.call(__MODULE__, {:move_down, {y, x}})

  @spec get_board :: Matrix.t
  def get_board, do: GenServer.call(__MODULE__, :get_board)

  # Callbacks

  def init(board) do
    {:ok, board}
  end

  def handle_call(:get_board, _, board), do: {:reply, {:ok, board}, board}

  def handle_call({:move_down, {y, x}}, _from, board) when y < 11 do
    do_move(:down, {x, y}, board)
  end

  def handle_call({:move_right, {y, x}}, _from, board) when x < 11 do
    do_move(:right, {x, y}, board)
  end

  def handle_call({:move_left, {y, x}}, _from, board) when x >= 0 do
    do_move(:left, {x, y}, board)
  end

  def handle_call({:move_up, {y, x}}, _from, board) when y >= 0 do
    do_move(:up, {x, y}, board)
  end

  # Internal functionality

  @spec can_move?(atom, atom) :: boolean
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

  @spec do_move(atom, {integer, integer}, Matrix.t) :: {:reply, {:ok, Matrix.t}, Matrix.t}
  def do_move(direction, {x, y}, board) do
    piece = board[y][x]
    new_position =
      case direction do
        :right -> board[y][x + 1]
        :left -> board[y][x - 1]
        :up -> board[y - 1][x]
        :down -> board[y + 1][x]
      end

    if can_move?(piece, new_position) do
      new_board =
        case direction do
          :right ->
            Map.update!(board, y, fn(row) ->
              Map.update!(row, x, fn(_) -> :empty end)
              |> Map.update!(x + 1, fn(_) -> piece end)
            end)
          :left ->
            Map.update!(board, y, fn(row) ->
              Map.update!(row, x, fn(_) -> :empty end)
              |> Map.update!(x - 1, fn(_) -> piece end)
            end)
          :up ->
            Map.update!(board, y, fn(row) ->
              Map.update!(row, x, fn(_) -> :empty end)
            end)
            |> Map.update!(y - 1, fn(row) ->
              Map.update!(row, x, fn(_) -> piece end)
            end)
          :down ->
            Map.update!(board, y, fn(row) ->
              Map.update!(row, x, fn(_) -> :empty end)
            end)
            |> Map.update!(y + 1, fn(row) ->
              Map.update!(row, x, fn(_) -> piece end)
            end)
        end

      {:reply, {:ok, new_board}, new_board}
    else
      {:reply, {:error, :invalid_move}, board}
    end
  end
end
