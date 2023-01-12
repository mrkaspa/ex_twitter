defmodule ExTwitterWeb.TweetController do
  use ExTwitterWeb, :controller

  alias ExTwitter.Tweets
  alias ExTwitter.Tweets.Tweet

  def new(conn, _params) do
    changeset = Tweet.changeset(%Tweet{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tweet" => tweet_params}) do
    user = conn.assigns.current_user

    case Tweets.create_tweet(Map.put(tweet_params, "user_id", user.id)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Tweet created successfully.")
        |> redirect(to: Routes.tweet_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, tweet} <- Tweets.get_tweet(id) do
      render(conn, "show.html", tweet: tweet)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, tweet} <- Tweets.get_tweet(id) do
      {:ok, _tweet} = Tweets.delete_tweet(tweet)

      conn
      |> put_flash(:info, "Tweet deleted successfully.")
      |> redirect(to: NavigationHistory.last_path(conn) || Routes.page_path(conn, :index))
    end
  end
end
