defmodule HnefaWeb.GameController do
  use HnefaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
