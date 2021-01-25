defmodule AshAuditLog.Transformers.AddResources do
  @moduledoc "Adds the generated audit log to the resource's notifiers"
  use Ash.Dsl.Transformer

  import AshAuditLog.Resource, only: [audit_log_module: 1]

  alias Ash.Dsl.Transformer

  def before?(Ash.Api.Transformers.ValidateRelatedResourceInclusion), do: true
  def before?(_), do: false

  def transform(_resource, dsl) do
    dsl =
      dsl
      |> Transformer.get_entities([:resources])
      |> Enum.reduce(dsl, &maybe_add_entity/2)

    {:ok, dsl}
  end

  defp maybe_add_entity(%{resource: resource}, dsl) do
    new_entity = %Ash.Api.ResourceReference{
      resource: audit_log_module(resource)
    }

    if uses_audit_log?(resource) do
      Transformer.add_entity(dsl, [:resources], new_entity)
    else
      dsl
    end
  end

  defp uses_audit_log?(resource) do
    dsl = resource.ash_dsl_config()
    AshAuditLog in Transformer.get_persisted(dsl, :extensions, [])
  end
end
