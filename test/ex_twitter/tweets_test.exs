defmodule ExTwitter.TweetsTest do
  use ExTwitter.DataCase

  alias ExTwitter.Tweets
  alias ExTwitter.Tweets.Tweet

  setup do
    {:ok, tweet: insert(:tweet)}
  end

  describe "list_tweets/1" do
    test "returns all tweets", %{tweet: tweet} do
      assert %Scrivener.Page{entries: [tweet_found]} = Tweets.list_tweets(%{})
      assert tweet_found.id == tweet.id
    end
  end

  describe "get_tweet!/1" do
    test "returns the tweet with given id", %{tweet: tweet} do
      assert {:ok, %Tweet{} = tweet_found} = Tweets.get_tweet(tweet.id)
      assert tweet_found.id == tweet.id
    end
  end

  describe "create_tweet/1" do
    test "with valid data creates a tweet" do
      user = insert(:user)
      valid_attrs = params_for(:tweet, user_id: user.id)

      assert {:ok, %Tweet{} = tweet} = Tweets.create_tweet(valid_attrs)
      assert tweet.body == valid_attrs[:body]
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Tweets.create_tweet(%{body: nil})

      assert %{body: ["can't be blank"], user_id: ["can't be blank"]} = errors_on(changeset)
    end

    test "with invalid body length changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Tweets.create_tweet(%{
                 body:
                   "some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body some updated body"
               })

      assert %{body: ["should be at most 280 character(s)"], user_id: ["can't be blank"]} =
               errors_on(changeset)
    end
  end

  describe "delete_tweet/1" do
    test "deletes the tweet", %{tweet: tweet} do
      assert {:ok, %Tweet{}} = Tweets.delete_tweet(tweet)
      assert {:error, :not_found} = Tweets.get_tweet(tweet.id)
    end
  end
end
