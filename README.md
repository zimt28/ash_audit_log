# AshAuditLog

**🚧 This library is still work in progress and shouldn't be used yet.**

`AshAuditLog` is an [Ash](https://github.com/ash-project/ash) extension that lets you track resource changes by writing to an audit log.

Changes get tracked per resource, an audit log resource and database table get generated automatically. The extension is currently limited to be used with Postgres, but can easily be extended to other data layers once the need arises.

## Installation

The package hasn't been published to hex yet. It can be installed from GitHub by adding `ash_audit_log` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ash_audit_log, github: "zimt28/ash_audit_log"}
  ]
end
```

If you're using the Elixir formatter, add `ash_audit_log` to `import_deps` in your `.formatter.exs` file:

```elixir
[
  import_deps: [:ecto, :phoenix, :ash, :ash_postgres, :ash_audit_log],
]
```

## Usage


### 1. Add the `AshAuditLog` extension to your resource

You can add an `audit_log` section to configure the extension's behavior, this isn't required though.

```elixir
defmodule App.Context.Resource do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuditLog]
  
  postgres do
    repo App.Repo
    table "resources"
  end

  audit_log do
    actor App.Users.User
    ignore_fields [:id, :inserted_at, :updated_at]
  end

  attributes do
    attribute :title, :string, allow_nil?: false
  end
end
```

### 2. Add the `AshAuditLog.Api` extension to your api

```elixir
defmodule App.Api do
  use Ash.Api,
    extensions: [AshAuditLog.Api]
  
  resources do
    resource App.Context.Resource
  end
end
```

### 3. Generate & run the migration

> ⚠️ **Attention:** Until Ash adds support for modifying `on_delete` behavior, you need to add `on_delete: :delete_all` to the `resource_id` in the migration.

Generate a migration for the audit log table by running

```
> mix ash_postgres.generate_migrations --apis App.Api
> mix ecto.migrate
```

### 4. Done

From now on `AshAuditLog` will write every action you perform on the resource to the audit log. Functions for querying and reverting changes will be added soon.