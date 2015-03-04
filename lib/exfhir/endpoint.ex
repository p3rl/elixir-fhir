defmodule ExFhir.Endpoint do
  use Phoenix.Endpoint, otp_app: :ex_fhir

  # Serve at "/" the given assets from "priv/static" directory
  plug Plug.Static,
    at: "/", from: :ex_fhir,
    only: ~w(css images js favicon.ico robots.txt)

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_ex_fhir_key",
    signing_salt: "k5HlAsxx",
    encryption_salt: "nisQ0We7"

  plug :router, ExFhir.Router
end
