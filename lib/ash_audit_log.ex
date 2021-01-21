defmodule AshAuditLog do
  @audit_log %Ash.Dsl.Section{
    name: :audit_log,
    describe: "",
    schema: [
      api: [
        type: :atom,
        required: true,
        doc: "The api to be used"
      ],
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
  def api(resource) do
    Extension.get_opt(resource, [:audit_log], :api, nil, true)
  end

  @doc "Fields that don't get tracked in the audit log"
  def ignore_fields(resource) do
    Extension.get_opt(resource, [:audit_log], :ignore_fields, [], true)
  end
end
