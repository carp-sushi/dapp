# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Dapp.Repo
alias Dapp.Data.Schema.{Role, User}

# Roles
admin = Repo.insert!(%Role{name: "Admin"})
user = Repo.insert!(%Role{name: "User"})

# Users
Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska",
    email: "alice@gmail.com",
    name: "Alice",
    role: admin
  }
)
Repo.insert!(
  %User{
    blockchain_address: "tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kskb",
    email: "bob@gmail.com",
    name: "Bob",
    role: user
  }
)
