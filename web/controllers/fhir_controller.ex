defmodule ExFhir.FhirController do
  use Phoenix.Controller

  plug :action

  def get_resources(conn, %{"resource_type" => resource_type}) do
    resource_type
    |> ExFhir.FhirService.get_all
    |> to_json(conn)
  end

  def get_resource_instance(conn, %{"resource_type" => resource_type, "id" => id}) do
    resource_type
    |> ExFhir.FhirService.get_resource(id)
    |> to_json(conn)
  end

  def get_resource_instance_version(conn, %{"resource_type" => resource_type, "id" => id, "version" => version}) do
    resource_type
    |> ExFhir.FhirService.get_resource_version(id, version)
    |> to_json(conn)
  end

  defp to_json(response, conn) do
    json conn, response
  end
end
