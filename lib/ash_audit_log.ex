defmodule AshAuditLog do
  @audit_log %Ash.Dsl.Section{
    name: :audit_log,
    describe: "",
    schema: [
      actor: [
        type: :atom,
        doc: "The actor, must be an Ash resource"
      ],
      ignore_fields: [
        type: {:list, :atom},
        doc: "Fields that won't get tracked in the audit log"
      ],
      private?: [
        type: :boolean,
        default: true,
        doc: "Set the `private?` option on the has_many relationship to the resource's audit log"
      ]
    ]
  }

  use Ash.Dsl.Extension,
    sections: [@audit_log],
    transformers: [
      AshAuditLog.Transformers.VerifyResource,
      AshAuditLog.Transformers.VerifyDataLayer,
      AshAuditLog.Transformers.VerifyActor,
      AshAuditLog.Transformers.CreateResource,
      AshAuditLog.Transformers.AddRelationship,
      AshAuditLog.Transformers.AddNotifier
      # AshAuditLog.Transformers.Inspect
    ]

  alias Ash.Dsl.Extension

  @doc "The actor resource"
  def actor(resource),
    do: opt(resource, :actor)

  @doc "Fields that don't get tracked in the audit log"
  def ignore_fields(resource),
    do: opt(resource, :ignore_fields, [])

  @doc "Whether or not the has_many relationship to the audit log should be private"
  def private?(resource),
    do: opt(resource, :private?)

  defp opt(resource, opt, default \\ nil) do
    default = default || get_in(@audit_log.schema, [opt, :default])

    Extension.get_opt(resource, [:audit_log], opt, default, true)
  end
end
