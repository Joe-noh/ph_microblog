ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PhMicroblog.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhMicroblog.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(PhMicroblog.Repo, :manual)
