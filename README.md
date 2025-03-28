# Elixir template

A web-service template with role-based access control (RBAC).

## Setup

First, install the [asdf version manager](https://asdf-vm.com/guide/getting-started.html).
Then, add the [asdf erlang](https://github.com/asdf-vm/asdf-erlang)
and [asdf elixir](https://github.com/asdf-vm/asdf-elixir)
plugins.

See `.tool-versions` for version details.

Once the above are installed, run the following command.

```shell
asdf install
```

Run a PostgreSQL database container (assumes docker is installed).

```shell
docker run --rm --name dapp-postgres -p 5432:5432 -e POSTGRES_PASSWORD=password1 -e POSTGRES_USER=postgres -d postgres
```

Get deps, create the db, run migrations, and seed the database with sample data.

```shell
mix setup
```

Drop into an interactive shell + start the application in dev mode.

```shell
iex -S mix
```

## Examples - Invite / Signup Flow

### Get Roles (admin)

```shell
curl -is -XGET -H "x-account-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" http://localhost:8081/dapp/api/v1/roles
```

Note the `role_id` for "User" for creating invite below.

### Create Invite (admin)

```shell
curl -is -XPOST \
  -H "x-account-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kska" \
  -H "content-type: application/json" \
  -d '{"email": "jon@duck.com", "role_id": 2}' \
  http://localhost:8081/dapp/api/v1/invites
```

Copy the invite code from the response for the next step.

### Signup

It is assumed the invited user makes this request, not the admin. Note the different account
address header.

```shell
curl -is -XPOST \
  -H "x-account-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kjon" \
  -H "content-type: application/json" \
  -d '{"name": "Jon Doe", "email": "jon@duck.com", "invite_code": "FIXME"}' \
  http://localhost:8081/dapp/api/v1/signup
```

### Get Profile

The new user should be able to access their profile.

```shell
curl -is -XGET -H "x-account-address: tp18vd8fpwxzck93qlwghaj6arh4p7c5n89x8kjon" http://localhost:8081/dapp/api/v1/users/profile
```
