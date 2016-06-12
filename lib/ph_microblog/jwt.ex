defmodule PhMicroblog.Jwt do
  import Joken

  @secret Application.get_env(:ph_microblog, PhMicroblog.Endpoint)[:secret_key_base]

  def decode(jwt) do
    jwt
    |> token()
    |> with_signer(hs256 @secret)
    |> verify()
  end

  def encode(user) do
    %{user_id: user.id, user_name: user.name}
    |> token()
    |> with_signer(hs256 @secret)
    |> sign()
    |> get_compact()
  end
end
