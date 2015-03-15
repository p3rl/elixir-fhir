defmodule ExFhir.FhirController do
  use Phoenix.Controller
  alias ExFhir.FhirService, as: FhirService
  plug :action

  def get_all_resources(conn, %{"resourcetype" => resourcetype}) do
    FhirService.get_all(resourcetype) |> create_response(conn)
  end

  def get_resource(conn, %{"resourcetype" => resourcetype, "id" => id}) do
    resourcetype
    |> FhirService.get_resource(id)
    |> create_response(conn)
  end

  def get_resource_version(conn, %{"resourcetype" => resourcetype, "id" => id, "version" => version}) do
    resourcetype
    |> FhirService.get_resource_version(id, version)
    |> create_response(conn)
  end

  def create_resource(conn, %{"resourcetype" => resourcetype}) do
    body =
      conn.params
      |> Dict.delete("format")
      |> Dict.delete("resourcetype")

    resourcetype
    |> FhirService.create_resource(body)
    |> create_response(conn)
  end

  defp create_response({:ok, resource}, conn) do
    json conn, resource
  end

  defp create_response({:error, reason}, conn) do
    json conn, %{"reason" => reason}
  end
end
