defmodule ExTwitterWeb.AccountController do
  use ExTwitterWeb, :controller

  alias ExTwitter.{Accounts, Friendships}

  def new_search(conn, _params) do
    render(conn, "search.html", user: nil)
  end

  def search(%{assigns: %{current_user: current_user}} = conn, %{"search" => search}) do
    with {:ok, user} <- Accounts.get_user_by_username(search) do
      follow_user = Friendships.follow_user?(current_user.id, user.id)

      render(conn, "search.html", user: user, follow_user: follow_user)
    end
  end
end
