defmodule ExTwitter.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :body, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
