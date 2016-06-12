defmodule PhMicroblog.Jwt do
  import Joken

  @secret Application.get_env(:ph_microblog, PhMicroblog.Endpoint)[:secret_key_base]

  @spec decode(String.t) :: {:ok, map} | {:error, String.t}
  def decode(jwt) do
    jwt
    |> token()
    |> with_signer(hs256 @secret)
    |> verify!()
  end

  @spec encode(map) :: String.t
  def encode(user) do
    %{user_id: user.id, user_name: user.name}
    |> token()
    |> with_signer(hs256 @secret)
    |> sign()
    |> get_compact()
  end
end
