defmodule ExFhir.FhirController do
  use Phoenix.Controller

  alias ExFhir.FhirService, as: FhirService

  plug :action

  def get_resources(conn, %{"resource_type" => resource_type}) do
    resource_type
    |> FhirService.get_all
    |> to_json(conn)
  end

  def get_resource_instance(conn, %{"resource_type" => resource_type, "id" => id}) do
    resource_type
    |> FhirService.get_resource(id)
    |> to_json(conn)
  end

  def get_resource_instance_version(conn, %{"resource_type" => resource_type, "id" => id, "version" => version}) do
    resource_type
    |> FhirService.get_resource_version(id, version)
    |> to_json(conn)
  end

  def create_resource(conn, %{"resource_type" => resource_type}) do
    body = Dict.delete(conn.params, "format")
    case FhirService.create_resource(resource_type, body) do
      {:ok, resource} -> json conn, resource
      {:error, reason} -> process_error(conn, reason)
    end
  end

  defp to_json(response, conn) do
    json conn, response
  end

  defp create_error_response(conn, reason) do
    %{"reason" => reason.message, "error_code" => 400}
  end

  defp process_error(conn, reason) do
    conn
    |> create_error_response(reason)
    |> to_json(conn)
  end
end
