defmodule ExFhir.FhirService do
  require Logger

  alias ExFhir.FhirRepository, as: FhirRepo
  alias ExFhir.Model.ResourceBaseContent, as: ResourceBaseContent

  @baseurl "http://localhost"

  def get_all(resourcetype) do
    Logger.info "[FhirService] get all (#{resourcetype})"
    FhirRepo.get_all(resourcetype)
  end

  def get_resource(resource_type, id) do
    Logger.info "[FhirService] get resource (#{resource_type}, #{id})"
    %{"resourceType" => resource_type, "id" => id}
  end

  def get_resource_version(resource_type, id, version) do
    Logger.info "[FhirService] get resource version (#{resource_type}, #{id}, #{version})"
    %{"resourceType" => resource_type, "id" => id, "version" => version}
  end

  def create_resource(resource_type, resource) do
    Logger.info "[FhirService] create resource #{resource_type}"

    try do
      ResourceBaseContent.from_resource(resource)
      |> FhirRepo.insert(resource)
      |> success
    rescue
      e in RuntimeError -> {:error, %{message: "FAIL", error_code: 400}}
    end
  end

  defp success(resource), do: {:ok, resource}

end
