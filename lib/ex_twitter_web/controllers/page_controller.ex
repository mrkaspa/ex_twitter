defmodule ExTwitterWeb.PageController do
  use ExTwitterWeb, :controller
  alias ExTwitter.{Accounts, Tweets}
  alias ExTwitter.Accounts.User
  alias ExTwitter.Friendships

  def index(%{assigns: %{current_user: user}} = conn, params) when not is_nil(user) do
    follows = Friendships.get_all_follows(%{user_id: user.id})

    params =
      params
      |> Morphix.atomorphiform!()
      |> Map.put(:user_ids, [user.id | Enum.map(follows, & &1.id)])

    page = Tweets.list_tweets(params)

    render(
      conn,
      "index.html",
      assing_friendship_info([page: page], user.id)
    )
  end

  def index(conn, params) do
    page = Tweets.list_tweets(Morphix.atomorphiform!(params))

    render(conn, "index.html", page: page)
  end

  def show(%{assigns: %{current_user: current_user}} = conn, %{"id" => username} = params) do
    with {:ok, %User{id: user_id} = user} <- Accounts.get_user_by_username(username) do
      params =
        params
        |> Morphix.atomorphiform!()
        |> Map.put(:user_id, user_id)

      page = Tweets.list_tweets(params)

      follow_user = Friendships.follow_user?(current_user.id, user.id)

      render(
        conn,
        "show.html",
        assing_friendship_info([page: page, user: user, follow_user: follow_user], user.id)
      )
    end
  end

  defp assing_friendship_info(assigns, user_id) do
    followers_counter = Friendships.count_followers(%{user_id: user_id})
    follows_counter = Friendships.count_follows(%{user_id: user_id})

    Keyword.merge(assigns,
      follows_counter: follows_counter,
      followers_counter: followers_counter
    )
  end
end
