defmodule AshAuditLog.Resource do
  @moduledoc false

  import AshAuditLog, only: [actor: 1, actor_pk: 1]

  def audit_log_module(resource) do
    resource
    |> Atom.to_string()
    |> Kernel.<>("AuditLog")
    |> String.to_atom()
  end

  def audit_log_module_contents(resource, dsl) do
    repo = get_in(dsl, [[:postgres], :opts, :repo])
    table = get_in(dsl, [[:postgres], :opts, :table]) <> "_audit_log"

    actor = actor(resource)
    actor_pk = actor_pk(resource)

    quote do
      @moduledoc false
      use Ash.Resource,
        data_layer: AshPostgres.DataLayer

      use Ash.Notifier

      @doc false
      def notify(notification), do: AshAuditLog.Notifier.handle_notification(notification)

      postgres do
        repo unquote(repo)
        table unquote(table)
      end

      attributes do
        uuid_primary_key :id

        attribute :action, :atom, allow_nil?: false
        attribute :changes, :map, allow_nil?: false

        create_timestamp :inserted_at
      end

      relationships do
        belongs_to :resource, unquote(resource), required?: true

        if unquote(actor) do
          belongs_to :actor, unquote(actor), destination_field: unquote(actor_pk)
        end
      end
    end
  end
end
