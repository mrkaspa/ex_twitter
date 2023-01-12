defmodule ExTwitterWeb.FriendshipController do
  use ExTwitterWeb, :controller

  alias ExTwitter.{Accounts, Friendships}
  alias ExTwitter.Accounts.User

  def create(%{assigns: %{current_user: current_user}} = conn, %{"user_id" => user_id}) do
    Friendships.follow_user(current_user.id, user_id)
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have successfully followed the user")

      {:error, _} ->
        conn
        |> put_flash(:error, "Error following the user")
    end
    |> redirect(to: NavigationHistory.last_path(conn) || Routes.page_path(conn, :index))
  end

  def delete(%{assigns: %{current_user: current_user}} = conn, %{"id" => user_id}) do
    Friendships.unfollow_user(current_user.id, user_id)
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have successfully unfollowed the user")

      {:error, _} ->
        conn
        |> put_flash(:error, "Error unfollowing the user")
    end
    |> redirect(to: NavigationHistory.last_path(conn) || Routes.page_path(conn, :index))
  end

  def follows(
        %{assigns: %{current_user: current_user}} = conn,
        %{"page_id" => username} = params
      ) do
    with {:ok, %User{id: user_id}} <- Accounts.get_user_by_username(username) do
      params =
        params
        |> Morphix.atomorphiform!()
        |> Map.put(:user_id, user_id)

      page = Friendships.get_follows(params)

      %Scrivener.Page{entries: follows} =
        Friendships.get_follows(%{
          user_id: current_user.id,
          ids: Enum.map(page.entries, & &1.id)
        })

      my_follows_ids = Enum.map(follows, & &1.id)
      render(conn, "index.html", page: page, my_follows_ids: my_follows_ids, username: username)
    end
  end

  def followers(
        %{assigns: %{current_user: current_user}} = conn,
        %{"page_id" => username} = params
      ) do
    with {:ok, %User{id: user_id}} <- Accounts.get_user_by_username(username) do
      params =
        params
        |> Morphix.atomorphiform!()
        |> Map.put(:user_id, user_id)

      page = Friendships.get_followers(params)

      %Scrivener.Page{entries: follows} =
        Friendships.get_follows(%{
          user_id: current_user.id,
          ids: Enum.map(page.entries, & &1.id)
        })

      my_follows_ids = Enum.map(follows, & &1.id)
      render(conn, "index.html", page: page, my_follows_ids: my_follows_ids, username: username)
    end
  end
end
