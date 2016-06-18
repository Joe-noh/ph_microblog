defmodule PhMicroblog.JwtTest do
  use PhMicroblog.ModelCase, async: true

  alias PhMicroblog.Jwt

  setup do
    user = PhMicroblog.Factory.create(:michael)

    {:ok, [user: user]}
  end

  describe "encode/1" do
    test "returns a string", %{user: user} do
      assert Jwt.encode(user) |> is_binary
    end
  end

  describe "decode/1" do
    setup %{user: user} do
      {:ok, [token: Jwt.encode(user)]}
    end

    test "result includes user_id and user_name", %{token: token} do
      {:ok, result} = Jwt.decode(token)

      assert result["user_id"]
      assert result["user_name"]
    end

    @tag :capture_log
    test "returns error tuple when token is invalid" do
      assert {:error, _} = Jwt.decode("aaaaaaaaa")
    end
  end
end
