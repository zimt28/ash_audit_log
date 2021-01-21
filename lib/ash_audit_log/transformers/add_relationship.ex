defmodule AshAuditLog.Transformers.AddRelationship do
  @moduledoc "Adds a relationship to the resource"
  use Ash.Dsl.Transformer

  import AshAuditLog.Resource, only: [audit_log_module: 1]

  alias Ash.Dsl.Transformer

  def transform(resource, dsl) do
    dsl = Map.put_new(dsl, [:relationships], %{entities: [], opts: []})

    relationship = %Ash.Resource.Relationships.HasMany{
      cardinality: :many,
      description: nil,
      destination: audit_log_module(resource),
      destination_field: :resource_id,
      name: :audit_logs,
      # TODO: true
      private?: true,
      source: resource,
      source_field: :id,
      type: :has_many,
      # TODO: false
      writable?: false
    }

    dsl = Transformer.add_entity(dsl, [:relationships], relationship)

    {:ok, dsl}
  end
end
