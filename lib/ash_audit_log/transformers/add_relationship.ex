defmodule AshAuditLog.Transformers.AddRelationship do
  @moduledoc "Adds a relationship to the resource"
  use Ash.Dsl.Transformer

  import AshAuditLog, only: [private?: 1]
  import AshAuditLog.Resource, only: [audit_log_module: 1]

  alias Ash.Dsl.Transformer

  def before?(Ash.Api.Transformers.EnsureResourcesCompiled), do: true
  def before?(_), do: false

  def transform(resource, dsl) do
    dsl = Map.put_new(dsl, [:relationships], %{entities: [], opts: []})

    relationship = %Ash.Resource.Relationships.HasMany{
      destination: audit_log_module(resource),
      destination_field: :resource_id,
      name: :audit_logs,
      private?: private?(resource),
      source: resource,
      source_field: :id,
      writable?: false
    }

    dsl = Transformer.add_entity(dsl, [:relationships], relationship)

    {:ok, dsl}
  end
end
