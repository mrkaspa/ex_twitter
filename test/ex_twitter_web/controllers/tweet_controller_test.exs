defmodule ExTwitterWeb.TweetControllerTest do
  use ExTwitterWeb.ConnCase

  import ExTwitter.TweetsFixtures

  @create_attrs %{body: "some body"}
  @invalid_attrs %{
    body:
      "some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body"
  }

  setup :register_and_log_in_user

  describe "new tweet" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tweet_path(conn, :new))
      assert html_response(conn, 200) =~ "Post"
    end
  end

  describe "create tweet" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: @create_attrs)
      assert redirected_to(conn) == Routes.tweet_path(conn, :new)
      assert get_flash(conn, :info) =~ "Tweet created successfully"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: @invalid_attrs)
      assert html_response(conn, 200) =~ "should be at most 280 character(s)"
    end
  end

  describe "delete tweet" do
    setup [:create_tweet]

    test "deletes chosen tweet", %{conn: conn, tweet: tweet} do
      conn = delete(conn, Routes.tweet_path(conn, :delete, tweet))
      assert get_flash(conn, :info) =~ "Tweet deleted successfully"
    end
  end

  defp create_tweet(%{user: user}) do
    tweet = tweet_fixture(%{user_id: user.id})
    %{tweet: tweet}
  end
end
