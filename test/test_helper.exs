# Set the sandbox ownership mode. This ensures that only a single connection is used for each test.
Ecto.Adapters.SQL.Sandbox.mode(Dapp.Repo, :manual)

# Define mock role repo
Hammox.defmock(MockRoleRepo, for: Dapp.Data.Spec.RoleRepoSpec)
Application.put_env(:dapp, :role_repo, MockRoleRepo)

# Define mock user repo
Hammox.defmock(MockUserRepo, for: Dapp.Data.Spec.UserRepoSpec)
Application.put_env(:dapp, :user_repo, MockUserRepo)

# Define mock invite repo
Hammox.defmock(MockInviteRepo, for: Dapp.Data.Spec.InviteRepoSpec)
Application.put_env(:dapp, :invite_repo, MockInviteRepo)

# Run tests
ExUnit.start()
