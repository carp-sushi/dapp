defmodule Dapp.UseCase.User.GetProfileTest do
  use ExUnit.Case, async: true

  # Use case being tested
  alias Dapp.UseCase.User.GetProfile

  # Setup fake data
  setup do
    user = FakeData.generate_user()
    %{args: %{user: user}, expect: %{email: user.email}}
  end

  # GetProfile use case test
  describe "GetProfile" do
    test "should return the profile DTO for a user", ctx do
      assert {:ok, %{profile: profile}} = GetProfile.execute(ctx.args)
      assert profile.email == ctx.expect.email
    end

    test "should return an error when executed with empty args" do
      assert {:error, %{message: "missing required arg: user"}} = GetProfile.execute(%{})
    end
  end
end
