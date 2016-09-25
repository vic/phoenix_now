defmodule Now.PageController do
  use Now.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
