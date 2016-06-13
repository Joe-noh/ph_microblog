defmodule PhMicroblog.CorrectUser do
  import Plug.Conn
  import Phoenix.Controller
  import PhMicroblog.Router.Helpers

  alias PhMicroblog.Json.ErrorView

  def init(opts) do
    [
      accessor: Dict.get(opts, :accessor),
      mode:     Dict.get(opts, :mode)
    ]
  end

  def call(conn, opts) do
    current_user = conn.assigns.current_user
    resource_owner = Enum.reduce(opts[:accessor], conn.assigns, &Map.get(&2, &1))

    if current_user.id == resource_owner.id do
      conn
    else
      conn |> refuse(opts[:mode]) |> halt
    end
  end

  defp refuse(conn, :json) do
    conn
    |> put_status(401)
    |> render(ErrorView, "401.json")
  end

  defp refuse(conn, _) do
    conn |> redirect(to: static_page_path(conn, :home))
  end
end
