defmodule AshAuditLog.Notifier do
  @moduledoc ""

  import AshAuditLog, only: [api: 1, ignore_fields: 1]
  import AshAuditLog.Resource, only: [audit_log_module: 1]

  alias Ash.Changeset

  require Logger

  def handle_notification(%Ash.Notifier.Notification{
        resource: resource,
        action: %{type: action_type},
        changeset: %{attributes: changes},
        data: data,
        actor: _actor
      }) do
    audit_log_module = audit_log_module(resource)

    changes = Map.drop(changes, ignore_fields(resource))

    changeset =
      audit_log_module
      |> Changeset.new(%{
        action: action_type,
        changes: changes
      })
      |> Changeset.replace_relationship(:resource, data)

    api(resource).create(changeset)
  end

  def handle_notification(_notification) do
    Logger.info("Unhandled notification")
  end
end
