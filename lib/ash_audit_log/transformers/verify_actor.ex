defmodule AshAuditLog.Transformers.VerifyActor do
  @moduledoc "Verifies that the actor is an Ash resource"
  use Ash.Dsl.Transformer

  import AshAuditLog, only: [actor: 1, actor_pk: 1]

  def after?(_), do: true

  def transform(resource, dsl) do
    actor = actor(resource)
    actor_pk = actor_pk(resource)

    cond do
      actor == nil ->
        {:ok, dsl}

      Ash.Resource.Dsl not in (Ash.extensions(actor) || []) ->
        {:error, "The actor must be an Ash resource"}

      actor_pk not in Ash.Resource.primary_key(actor) ->
        {:error, "The specified primary key isn't an actual primary key"}

      true ->
        {:ok, dsl}
    end
  end
end
