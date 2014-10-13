ExUnit.start
Amrita.start

defmodule TestHelper do

  @port 4001

  def url(path) do
    "http://localhost:#{@port}#{path}"
  end

  def valid_user_params do
    %{"name"  => "joe",
      "email" => "joe@example.com",
      "password"     => "abcdefgh",
      "confirmation" => "abcdefgh"}
  end
end
