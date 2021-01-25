defmodule AshAuditLog.Transformers.VerifyActor do
  @moduledoc "Verifies that the actor is an Ash resource and has exactly one primary key"
  use Ash.Dsl.Transformer

  def after?(_), do: true

  def transform(_resource, dsl) do
    actor = get_in(dsl, [[:audit_log], :opts, :actor])

    cond do
      actor == nil ->
        {:ok, dsl}

      Ash.Resource.Dsl not in (Ash.extensions(actor) || []) ->
        {:error, "The actor must be an Ash resource"}

      Ash.Resource.primary_key(actor) |> length() != 1 ->
        {:error, "The actor resource must have exacly one primary key"}

      true ->
        {:ok, dsl}
    end
  end
end
