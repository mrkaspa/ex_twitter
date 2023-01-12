defmodule ExTwitter.Friendships do
  alias ExTwitter.Repo
  alias ExTwitter.Accounts.Friendship
  import Ecto.Query

  def follow_user(user_id, id_to_follow) do
    %Friendship{}
    |> Friendship.changeset(%{
      follow_id: id_to_follow,
      followed_by_id: user_id
    })
    |> Repo.insert()
  end

  def unfollow_user(user_id, id_to_follow) do
    friendship = get_friendship(user_id, id_to_follow)

    if friendship != nil do
      Repo.delete(friendship)
    else
      {:error, :not_found}
    end
  end

  def follow_user?(user_id, id_to_follow) do
    get_friendship(user_id, id_to_follow) != nil
  end

  def get_friendship(user_id, id_to_follow) do
    query =
      from f in Friendship,
        where:
          f.followed_by_id == ^user_id and
            f.follow_id == ^id_to_follow

    Repo.one(query)
  end

  def get_followers(params) do
    params
    |> Map.get(:user_id)
    |> followers_query()
    |> Repo.paginate(params)
  end

  def get_follows(params) do
    params
    |> Map.get(:user_id)
    |> follows_query()
    |> filter_follows_by_ids(params)
    |> Repo.paginate(params)
  end

  def get_all_follows(params) do
    params
    |> Map.get(:user_id)
    |> follows_query()
    |> Repo.all()
  end

  def count_follows(params) do
    params
    |> Map.get(:user_id)
    |> follows_query()
    |> Repo.aggregate(:count)
  end

  def count_followers(params) do
    params
    |> Map.get(:user_id)
    |> followers_query()
    |> Repo.aggregate(:count)
  end

  defp followers_query(user_id) do
    from f in Friendship,
      join: u in assoc(f, :followed_by),
      select: u,
      where: f.follow_id == ^user_id
  end

  defp follows_query(user_id) do
    from f in Friendship,
      as: :friendship,
      join: u in assoc(f, :follow),
      as: :user,
      select: u,
      where: f.followed_by_id == ^user_id
  end

  defp filter_follows_by_ids(query, %{ids: ids}) do
    from([user: u] in query, where: u.id in ^ids)
  end

  defp filter_follows_by_ids(query, _params), do: query
end
