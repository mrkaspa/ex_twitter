defmodule ExTwitter.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tweets" do
    field :body, :string

    belongs_to :user, ExTwitter.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
    |> assoc_constraint(:user)
    |> validate_length(:body, max: 280)
  end
end
