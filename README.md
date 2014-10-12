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
5. Execute `mix test` and confirm it's green
6. Start Phoenix router with `mix phoenix.start`
7. Visit `localhost:4567`

## Testing

I'm in trouble over end-to-end testing. I tried [tuco\_tuco]{https://github.com/stuart/tuco\_tuco} and [hound](https://github.com/HashNuke/hound),
but something went wrong and test didn't run. For now I'm gonna write only unit tests with [amrita](https://github.com/josephwilk/amrita).

