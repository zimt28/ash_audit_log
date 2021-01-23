defmodule AshAuditLog do
  @audit_log %Ash.Dsl.Section{
    name: :audit_log,
    describe: "",
    schema: [
      ignore_fields: [
        type: {:list, :atom},
        doc: "Fields that won't get tracked in the audit log"
      ]
    ]
  }

  use Ash.Dsl.Extension,
    sections: [@audit_log],
    transformers: [
      AshAuditLog.Transformers.VerifyResource,
      AshAuditLog.Transformers.VerifyDataLayer,
      AshAuditLog.Transformers.AddRelationship,
      AshAuditLog.Transformers.AddNotifier,
      AshAuditLog.Transformers.CreateResource
      # AshAuditLog.Transformers.Inspect
    ]

  alias Ash.Dsl.Extension

  @doc "Fields that don't get tracked in the audit log"
  def ignore_fields(resource) do
    Extension.get_opt(resource, [:audit_log], :ignore_fields, [], true)
  end

  # 01:57:53.447 [error] Could not ensure that resources [MiniERP.Accounts.Account] were compiled
  # Process.put(
  #   {__MODULE__, :ash, [:multitenancy]},
  #   %{
  #     entities: [],
  #     opts: []
  #   }
  # )
  #
  # sections = Process.get({__MODULE__, :ash_sections}, [])
  # sections = sections ++ [{Ash.Resource.Dsl, [:multitenancy]}]
  #
  # Process.put({__MODULE__, :ash_sections}, sections)
end
