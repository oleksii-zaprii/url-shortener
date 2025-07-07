defmodule UrlShortenerApi.Repo do
  use Ecto.Repo,
    otp_app: :url_shortener_api,
    adapter: Ecto.Adapters.Postgres
end
