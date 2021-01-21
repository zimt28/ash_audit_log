defmodule AshAuditLog.Transformers.AddRelationship do
  @moduledoc "Adds a relationship to the resource"
  use Ash.Dsl.Transformer

  import AshAuditLog.Resource, only: [audit_log_module: 1]

  def transform(resource, dsl) do
    dsl = Map.put_new(dsl, [:relationships], %{entities: [], opts: []})

    relationship = %Ash.Resource.Relationships.HasMany{
      cardinality: :many,
      description: nil,
      destination: audit_log_module(resource),
      destination_field: :resource_id,
      name: :audit_logs,
      # TODO: true
      private?: false,
      source: resource,
      source_field: :id,
      type: :has_many,
      # TODO: false
      writable?: true
    }

    entities = [relationship] ++ get_in(dsl, [[:relationships], :entities])
    dsl = put_in(dsl, [[:relationships], :entities], entities)

    {:ok, dsl}
  end
end
