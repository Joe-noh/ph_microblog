# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the router
config :phoenix, PhMicroblog.Router,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  https: false,
  secret_key_base: "EUJTlBrZ4B1Ojpk+NB2YW+thnw683bgPulR66kyfbcZ5C7G/9AaiR9tSzECiGd13SuWPT7p6fB99XeI7QakK3A==",
  cookies: true,
  catch_errors: true,
  debug_errors: false,
  error_controller: PhMicroblog.PageController

# Session configuration
config :phoenix, PhMicroblog.Router,
  session: [store: :cookie,
            key: "_ph_microblog_key"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :hound,
  driver: "chrome_driver"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
