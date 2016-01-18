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

  def find_by_name(name) do
    query = from u in HelloGraphQL.User,
      where: u.name == ^name
    # this could break if more than theres more than 1 user with same name.
    HelloGraphQL.Repo.one(query)
  end
  def find_by_id(id) do
    query = from u in HelloGraphQL.User,
      where: u.id == ^id
    HelloGraphQL.Repo.one(query)
  end
end
