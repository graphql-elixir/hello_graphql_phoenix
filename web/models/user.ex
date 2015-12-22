defmodule HelloGraphQL.User do
  use HelloGraphQL.Web, :model

  schema "users" do
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def find(user_id) do
    query = from u in HelloGraphQL.User,
      where: u.id == ^user_id
    HelloGraphQL.Repo.one(query)
  end
end
