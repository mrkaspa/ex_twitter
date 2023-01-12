defmodule ExTwitter.Accounts.Friendship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friendships" do
    belongs_to :follow, ExTwitter.Accounts.User, foreign_key: :follow_id
    belongs_to :followed_by, ExTwitter.Accounts.User, foreign_key: :followed_by_id

    timestamps()
  end

  @doc false
  def changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [:follow_id, :followed_by_id])
    |> validate_required([:follow_id, :followed_by_id])
    |> unique_constraint(:follow_id, name: :following_index)
    |> assoc_constraint(:follow)
    |> assoc_constraint(:followed_by)
    |> validate_not_follow_itself()
  end

  def validate_not_follow_itself(changeset) do
    if get_change(changeset, :follow_id) == get_change(changeset, :followed_by_id) do
      add_error(changeset, :follow_id, "can not follow itself")
    else
      changeset
    end
  end
end
