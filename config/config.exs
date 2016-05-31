# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ph_microblog, PhMicroblog.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "9hq1HVHyA1ap86br+fiYnyO26NF6tBR8pcVlLrRec3a9FV/hczKy6HkV/pOCtaBH",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: PhMicroblog.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :ph_microblog, ecto_repos: [PhMicroblog.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
