defmodule AshAuditLog.Transformers.AddResources do
  @moduledoc "Adds the generated audit log to the resource's notifiers"
  use Ash.Dsl.Transformer

  import AshAuditLog.Resource, only: [audit_log_module: 1]

  def before?(Ash.Api.Transformers.ValidateRelatedResourceInclusion), do: true
  def before?(_), do: false

  def transform(_resource, dsl) do
    entities =
      get_in(dsl, [[:resources], :entities])
      |> Enum.map(&maybe_add_resource_log_resource/1)
      |> List.flatten()

    dsl = put_in(dsl, [[:resources], :entities], entities)

    {:ok, dsl}
  end

  defp maybe_add_resource_log_resource(resource_reference) do
    resource = resource_reference.resource

    if uses_audit_log?(resource) do
      [
        resource_reference,
        %Ash.Api.ResourceReference{
          resource: audit_log_module(resource),
          warn_on_compile_failure?: false
        }
      ]
    else
      resource_reference
    end
  end

  defp uses_audit_log?(resource) do
    AshAuditLog in Ash.extensions(resource)
  end
end
