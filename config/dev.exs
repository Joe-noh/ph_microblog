use Mix.Config

config :phoenix, PhMicroblog.Router,
  port: System.get_env("PORT") || 4567,
  ssl: false,
  host: "localhost",
  session_key: "ph_microblog",
  debug_errors: true

# Enables code reloading for development
config :phoenix, :code_reloader, false

config :bcrypt,
  default_log_rounds: 4
