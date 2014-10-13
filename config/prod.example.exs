use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     ssl: true,
#     keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#     certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :phoenix, PhMicroblog.Router,
  url: [host: "example.com"],
  http: [port: System.get_env("PORT")],
  https: false,
  secret_key_base: "****************************************************************************************"

config :logger, :console,
  level: :info
