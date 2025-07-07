defmodule UrlShortenerApi.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :original_url, :string, null: false
      add :short_code, :string, null: false
      add :clicks, :integer, default: 0
      add :expires_at, :utc_datetime

      timestamps()
    end

    create unique_index(:urls, [:short_code])
    create index(:urls, [:original_url])
  end
end
