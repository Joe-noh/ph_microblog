ExUnit.start

defmodule TestHelper do
  @session_opts Plug.Session.init(store: :cookie, key: "_app",
                                  encryption_salt: "abc", signing_salt: "abc")

  def with_session(conn) do
    conn
    |> Map.put(:secret_key_base, String.duplicate("a", 64))
    |> Plug.Session.call(@session_opts)
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.fetch_params()
  end
end

