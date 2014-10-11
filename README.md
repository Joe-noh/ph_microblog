# PhMicroblog

__W.I.P__

## Try

To start this application:

1. Install dependencies with `mix do deps.get, deps.compile`
2. Create postgres database `ph_microblog_dev` and `ph_microblog_test`
3. Rename and modify contents
  * `lib/ph_microblog/repo.example.ex` to `lib/ph_microblog/repo.ex`
  * `config/prod.example.exs` to `config/prod.exs`
4. Migrate with `mix ecto.migrate PhMicroblog.Repo`
5. Execute `mix amrita` and confirm it's green
6. Start Phoenix router with `mix phoenix.start`
7. Visit `localhost:4567`
