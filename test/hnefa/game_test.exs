defmodule Hnefa.GameTest do
  use ExUnit.Case, async: true

  alias Hnefa.Game

  test "get_board/0 returns a tuple containing a map of the right dimensions" do
    assert {:ok, board} = Game.get_board()
    assert is_map(board)
    assert map_size(board) == 11
    assert map_size(Map.get(board, 0)) == 11
  end

  test "move/3 when moving right" do
    assert {:ok, new_board} = Game.move(:right, 3, 0)

    assert new_board[3][0] == :empty
    assert new_board[3][1] == :black
  end

  test "move/3 when moving left" do
    assert {:ok, new_board} = Game.move(:left, 3, 10)

    assert new_board[3][10] == :empty
    assert new_board[3][9] == :black
  end

  test "move/3 when moving up" do
    assert {:ok, new_board} = Game.move(:up, 10, 3)

    assert new_board[10][3] == :empty
    assert new_board[9][3] == :black
  end

  test "move/3 when moving down" do
    assert {:ok, new_board} = Game.move(:down, 0, 3)

    assert new_board[0][3] == :empty
    assert new_board[1][3] == :black
  end
end
