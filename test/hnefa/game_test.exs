defmodule Hnefa.GameTest do
  use ExUnit.Case, async: true

  alias Hnefa.Game

  test "get_board/0" do
    assert {:ok, board} = Game.get_board()
    assert is_map(board)
  end

  test "move/3" do
    assert {:ok, new_board} = Game.move(:right, 3, 0)

    assert new_board[3][0] == :empty
    assert new_board[3][1] == :black
  end
end
