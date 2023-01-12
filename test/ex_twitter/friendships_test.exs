defmodule ExTwitter.FriendshipsTest do
  use ExTwitter.DataCase
  alias ExTwitter.Friendships

  describe "follow_user/2" do
    setup do
      user_a = insert(:user)
      user_b = insert(:user)

      {:ok, user_a: user_a, user_b: user_b}
    end

    test "user_a follows user_b", %{user_a: user_a, user_b: user_b} do
      assert {:ok, _} = Friendships.follow_user(user_a.id, user_b.id)
    end

    test "can not follow user twice", %{user_a: user_a, user_b: user_b} do
      assert {:ok, _} = Friendships.follow_user(user_a.id, user_b.id)
      assert {:error, changeset} = Friendships.follow_user(user_a.id, user_b.id)

      assert %{
               follow_id: ["has already been taken"]
             } = errors_on(changeset)
    end

    test "can not follow itself", %{user_a: user_a} do
      assert {:error, changeset} = Friendships.follow_user(user_a.id, user_a.id)

      assert %{
               follow_id: ["can not follow itself"]
             } = errors_on(changeset)
    end
  end

  describe "unfollow_user/2" do
    setup do
      user_a = insert(:user)
      user_b = insert(:user)

      {:ok, user_a: user_a, user_b: user_b}
    end

    test "unfollows an user", %{user_a: user_a, user_b: user_b} do
      assert {:ok, _} = Friendships.follow_user(user_a.id, user_b.id)
      assert {:ok, _} = Friendships.unfollow_user(user_a.id, user_b.id)
    end
  end

  describe "follow_user?/2" do
    setup do
      user_a = insert(:user)
      user_b = insert(:user)

      {:ok, user_a: user_a, user_b: user_b}
    end

    test "unfollows an user", %{user_a: user_a, user_b: user_b} do
      assert {:ok, _} = Friendships.follow_user(user_a.id, user_b.id)
      assert Friendships.follow_user?(user_a.id, user_b.id) == true
      assert {:ok, _} = Friendships.unfollow_user(user_a.id, user_b.id)
      assert Friendships.follow_user?(user_a.id, user_b.id) == false
    end
  end

  describe "get_follows/1" do
    setup do
      user_a = insert(:user)
      user_b = insert(:user)
      user_c = insert(:user)

      insert(:friendship, follow: user_b, followed_by: user_a)
      insert(:friendship, follow: user_c, followed_by: user_a)

      {:ok, user_a: user_a, user_b: user_b, user_c: user_c}
    end

    test "get user_a follows", %{user_a: user_a, user_b: user_b, user_c: user_c} do
      assert %Scrivener.Page{total_entries: 2, entries: entries} =
               Friendships.get_follows(%{user_id: user_a.id})

      assert Enum.any?(entries, &(&1.id == user_b.id))
      assert Enum.any?(entries, &(&1.id == user_c.id))
    end

    test "get user_b follows", %{user_b: user_b} do
      assert %Scrivener.Page{total_entries: 0} = Friendships.get_follows(%{user_id: user_b.id})
    end
  end

  describe "get_followers/1" do
    setup do
      user_a = insert(:user)
      user_b = insert(:user)
      user_c = insert(:user)

      insert(:friendship, follow: user_a, followed_by: user_b)
      insert(:friendship, follow: user_a, followed_by: user_c)

      {:ok, user_a: user_a, user_b: user_b, user_c: user_c}
    end

    test "get user_a followers", %{user_a: user_a, user_b: user_b, user_c: user_c} do
      assert %Scrivener.Page{total_entries: 2, entries: entries} =
               Friendships.get_followers(%{user_id: user_a.id})

      assert Enum.any?(entries, &(&1.id == user_b.id))
      assert Enum.any?(entries, &(&1.id == user_c.id))
    end

    test "get user_b followers", %{user_b: user_b} do
      assert %Scrivener.Page{total_entries: 0} = Friendships.get_followers(%{user_id: user_b.id})
    end
  end

  describe "count_follows/1" do
    setup do
      user_a = insert(:user)
      user_b = insert(:user)
      user_c = insert(:user)

      insert(:friendship, follow: user_b, followed_by: user_a)
      insert(:friendship, follow: user_c, followed_by: user_a)

      {:ok, user_a: user_a, user_b: user_b, user_c: user_c}
    end

    test "count user_a follows", %{user_a: user_a} do
      assert Friendships.count_follows(%{user_id: user_a.id}) == 2
    end
  end

  describe "count_followers/1" do
    setup do
      user_a = insert(:user)
      user_b = insert(:user)
      user_c = insert(:user)

      insert(:friendship, follow: user_a, followed_by: user_b)
      insert(:friendship, follow: user_a, followed_by: user_c)

      {:ok, user_a: user_a, user_b: user_b, user_c: user_c}
    end

    test "get user_a followers", %{user_a: user_a} do
      assert Friendships.count_followers(%{user_id: user_a.id}) == 2
    end
  end
end
