defmodule AshAuditLog do
  @audit_log %Ash.Dsl.Section{
    name: :audit_log,
    describe: "",
    schema: [
      ignore_fields: [
        type: {:list, :atom},
        doc: "Fields that won't get tracked in the audit log"
      ],
      private?: [
        type: :boolean,
        default: false,
        doc: "Set the `private?` option on the has_many relationship to the resource's audit log"
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

  @doc "Whether or not the has_many relationship to the audit log should be private"
  def private?(resource) do
    Extension.get_opt(resource, [:audit_log], :private?, [], true)
  end
end
