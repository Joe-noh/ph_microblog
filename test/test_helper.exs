ExUnit.start
Amrita.start

defmodule TestHelper do

  @port Phoenix.Config.get([PhMicroblog.Router, :port])

  def url(path) do
    "http://localhost:#{@port}#{path}"
  end
end
