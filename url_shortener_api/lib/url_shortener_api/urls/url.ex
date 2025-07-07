defmodule UrlShortenerApi.Urls.Url do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "urls" do
    field :original_url, :string
    field :short_code, :string
    field :clicks, :integer, default: 0
    field :expires_at, :utc_datetime

    timestamps()
  end

  def changeset(url, attrs) do
    url
    |> cast(attrs, [:original_url, :short_code, :expires_at])
    |> validate_required([:original_url, :short_code])
    |> validate_url(:original_url)
    |> unique_constraint(:short_code)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, url ->
      uri = URI.parse(url)
      if uri.scheme in ["http", "https"] and uri.host do
        []
      else
        [{field, "must be a valid URL"}]
      end
    end)
  end
end
