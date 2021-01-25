defmodule AshAuditLog.Resource do
  @moduledoc false

  import AshAuditLog, only: [actor: 1]

  alias Ash.Dsl.Transformer

  def audit_log_module(resource) do
    resource
    |> Atom.to_string()
    |> Kernel.<>("AuditLog")
    |> String.to_atom()
  end

  def audit_log_module_contents(resource, dsl) do
    config = config(resource, dsl)

    quote do
      @moduledoc false
      use Ash.Resource,
        data_layer: AshPostgres.DataLayer

      use Ash.Notifier

      @doc false
      def notify(notification), do: AshAuditLog.Notifier.handle_notification(notification)

      postgres do
        repo unquote(config.repo)
        table unquote(config.table)
      end

      attributes do
        uuid_primary_key :id

        attribute :action, :atom, allow_nil?: false
        attribute :changes, :map, allow_nil?: false

        create_timestamp :inserted_at
      end

      relationships do
        belongs_to :resource, unquote(resource), required?: true

        if unquote(config.actor) do
          belongs_to :actor, unquote(config.actor), destination_field: unquote(config.actor_pk)
        end
      end
    end
  end

  defp config(resource, dsl) do
    repo = get_in(dsl, [[:postgres], :opts, :repo])
    table = get_in(dsl, [[:postgres], :opts, :table]) <> "_audit_log"

    actor = actor(resource)
    actor_pk = actor && primary_key(dsl)

    %{
      repo: repo,
      table: table,
      actor: actor(resource),
      actor_pk: actor_pk
    }
  end

  defp primary_key(dsl) do
    dsl
    |> Transformer.get_entities([:attributes])
    |> Enum.filter(&(&1.primary_key? == true))
    |> Enum.map(& &1.name)
    |> List.first()
  end
end
