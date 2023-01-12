defmodule ExTwitter.Tweets do
  @moduledoc """
  The Tweets context.
  """

  import Ecto.Query, warn: false
  alias ExTwitter.Repo

  alias ExTwitter.Tweets.Tweet

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  def list_tweets(params \\ %{}) do
    query =
      from t in Tweet,
        as: :tweet,
        preload: [:user],
        order_by: [desc: :inserted_at]

    query
    |> filter_by_user_id(params)
    |> filter_by_user_ids(params)
    |> Repo.paginate(params)
  end

  defp filter_by_user_id(query, %{user_id: user_id}) do
    from(
      [
        tweet: t
      ] in query,
      where: t.user_id == ^user_id
    )
  end

  defp filter_by_user_id(query, _), do: query

  defp filter_by_user_ids(query, %{user_ids: user_ids}) do
    from(
      [
        tweet: t
      ] in query,
      where: t.user_id in ^user_ids
    )
  end

  defp filter_by_user_ids(query, _), do: query

  @doc """
  Gets a single tweet.

  Raises `Ecto.NoResultsError` if the Tweet does not exist.

  ## Examples

      iex> get_tweet!(123)
      %Tweet{}

      iex> get_tweet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tweet(id) do
    case Repo.get(Tweet, id) do
      %Tweet{} = tweet -> {:ok, tweet}
      nil -> {:error, :not_found}
    end
  end

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tweet(attrs \\ %{}) do
    %Tweet{}
    |> Tweet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end
end
