defmodule ExTwitter.Factory do
  use ExMachina.Ecto, repo: ExTwitter.Repo

  def user_factory do
    %ExTwitter.Accounts.User{
      name: "Jhon Doe",
      username: unique_username(),
      email: unique_user_email(),
      password: valid_user_password(),
      hashed_password: Bcrypt.hash_pwd_salt(valid_user_password())
    }
  end

  def friendship_factory do
    %ExTwitter.Accounts.Friendship{
      follow: build(:user),
      followed_by: build(:user)
    }
  end

  def tweet_factory do
    %ExTwitter.Tweets.Tweet{
      body: "this is a body",
      user: build(:user)
    }
  end

  defp unique_user_email, do: "user#{System.unique_integer()}@example.com"
  defp unique_username, do: "user#{System.unique_integer()}"
  defp valid_user_password, do: "Helloworld1"
end
