defmodule UrlShortenerApi.Urls do
  import Ecto.Query, warn: false
  alias UrlShortenerApi.Repo
  alias UrlShortenerApi.Urls.Url

  def create_url(attrs \\ %{}) do
    short_code = generate_short_code()

    attrs_with_code = Map.put(attrs, "short_code", short_code)

    %Url{}
    |> Url.changeset(attrs_with_code)
    |> Repo.insert()
  end

  def get_url_by_short_code(short_code) do
    Repo.get_by(Url, short_code: short_code)
  end

  def increment_clicks(url) do
    url
    |> Url.changeset(%{clicks: url.clicks + 1})
    |> Repo.update()
  end

  def list_urls do
    Repo.all(Url)
  end

  defp generate_short_code do
    6
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, 6)
  end
end
