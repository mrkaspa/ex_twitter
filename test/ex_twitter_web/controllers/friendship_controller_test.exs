defmodule ExTwitterWeb.FriendshipControllerTest do
  use ExTwitterWeb.ConnCase

  setup :register_and_log_in_user

  describe "follows user" do
    setup :create_other_user

    test "gets a successfull flash", %{conn: conn, other_user: other_user} do
      conn = post(conn, Routes.friendship_path(conn, :create, %{user_id: other_user.id}))
      assert get_flash(conn, :info) =~ "You have successfully followed the user"
    end
  end

  describe "unfollows user" do
    setup :create_other_user

    test "gets a successfull flash", %{conn: conn, other_user: other_user} do
      conn = post(conn, Routes.friendship_path(conn, :create, %{user_id: other_user.id}))
      assert get_flash(conn, :info) =~ "You have successfully followed the user"

      conn = delete(conn, Routes.friendship_path(conn, :delete, other_user.id))
      assert get_flash(conn, :info) =~ "You have successfully unfollowed the user"
    end
  end
end
