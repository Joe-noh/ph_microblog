use Mix.Config

config :phoenix, PhMicroblog.Router,
  port: System.get_env("PORT") || 4001,
  ssl: false
