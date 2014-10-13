use Mix.Config

config :phoenix, PhMicroblog.Router,
  http: [port: System.get_env("PORT") || 4001],
  ssl: false

config :bcrypt,
  default_log_rounds: 4
