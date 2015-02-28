# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ph_microblog, PhMicroblog.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7LkAC5QutMgweLiE8V3PT7hq/JQWI+PNSdiWlSqSBR60gQTnqKhQZe6dK6vBTaYH",
  debug_errors: false,
  pubsub: [adapter: Phoenix.PubSub.PG2]

config :ph_microblog, PhMicroblog.Repo,
  url: "ecto://postgres:postgres@localhost/ph_microblog_dev"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
