defmodule UrlShortenerApiWeb.UrlController do
  use UrlShortenerApiWeb, :controller

  alias UrlShortenerApi.Urls

  def create(conn, %{"url" => url_params}) do
    case Urls.create_url(url_params) do
      {:ok, url} ->
        conn
        |> put_status(:created)
        |> json(%{
          data: %{
            id: url.id,
            original_url: url.original_url,
            short_code: url.short_code,
            short_url: build_short_url(url.short_code),
            clicks: url.clicks
          }
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  def redirect_url(conn, %{"short_code" => short_code}) do
    case Urls.get_url_by_short_code(short_code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "URL not found"})

      url ->
        Urls.increment_clicks(url)
        redirect(conn, external: url.original_url)
    end
  end

  def show(conn, %{"short_code" => short_code}) do
    case Urls.get_url_by_short_code(short_code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "URL not found"})

      url ->
        json(conn, %{
          data: %{
            id: url.id,
            original_url: url.original_url,
            short_code: url.short_code,
            short_url: build_short_url(url.short_code),
            clicks: url.clicks
          }
        })
    end
  end

  def index(conn, _params) do
    urls = Urls.list_urls()

    json(conn, %{
      data: Enum.map(urls, fn url ->
        %{
          id: url.id,
          original_url: url.original_url,
          short_code: url.short_code,
          short_url: build_short_url(url.short_code),
          clicks: url.clicks
        }
      end)
    })
  end

  defp build_short_url(short_code) do
    UrlShortenerApiWeb.Endpoint.url() <> "/#{short_code}"
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
