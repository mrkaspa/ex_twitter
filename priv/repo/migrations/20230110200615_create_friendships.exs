defmodule ExTwitter.Repo.Migrations.CreateFriendships do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :follow_id, references(:users, on_delete: :nothing)
      add :followed_by_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:friendships, [:follow_id])
    create index(:friendships, [:followed_by_id])
    create unique_index(:friendships, [:follow_id, :followed_by_id], name: :following_index)
  end
end
