defmodule ExTwitter.TweetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExTwitter.Tweets` context.
  """

  @doc """
  Generate a tweet.
  """
  def tweet_fixture(attrs \\ %{}) do
    {:ok, tweet} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> ExTwitter.Tweets.create_tweet()

    tweet
  end
end
