defmodule AshAuditLog.Resource do
  @moduledoc false

  def audit_log_module(resource) do
    resource
    |> Atom.to_string()
    |> Kernel.<>("AuditLog")
    |> String.to_atom()
  end

  def audit_log_module_contents(resource, dsl) do
    table = get_in(dsl, [[:postgres], :opts, :table]) <> "_audit_log"
    repo = get_in(dsl, [[:postgres], :opts, :repo])

    quote do
      @moduledoc false
      use Ash.Resource,
        data_layer: AshPostgres.DataLayer

      use Ash.Notifier

      @doc false
      def notify(notification), do: AshAuditLog.Notifier.handle_notification(notification)

      postgres do
        table unquote(table)
        repo(unquote(repo))
      end

      attributes do
        uuid_primary_key :id

        attribute :action, :atom, allow_nil?: false
        attribute :changes, :map, allow_nil?: false

        create_timestamp :inserted_at
      end

      relationships do
        belongs_to :resource, unquote(resource), required?: true
      end
    end
  end
end
