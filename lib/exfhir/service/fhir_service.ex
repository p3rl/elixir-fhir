defmodule ExFhir.FhirService do
  @baseurl "http://localhost"

  require Logger
  alias ExFhir.FhirRepo, as: FhirRepo

  def get_all(resourcetype) do
    Logger.info "[FhirService] get all (#{resourcetype})"
    FhirRepo.get_all(resourcetype)
  end

  def get_resource(resourcetype, id) when resourcetype !== "" and id !== "" do
    Logger.info "[FhirService] get resource (#{resourcetype}, #{id})"
    FhirRepo.get_resource(resourcetype, id: id)
  end

  def get_resource(resourcetype, _id) when is_nil(resourcetype) or resourcetype === "",
    do: {:error, "Invalid resource type"}

  def get_resource(_resourcetype, id) when is_nil(id) or id === "",
    do: {:error, "Invalid resource id"}

  def get_resource_version(resourcetype, id, vid) when resourcetype !== "" and id !== "" and vid !== "" do
    Logger.info "[FhirService] get resource version (#{resourcetype}, #{id}, #{vid})"
    FhirRepo.get_resource(resourcetype, id: id, vid: vid)
  end

  def create_resource(resourcetype, %{"resourceType" => type}) when resourcetype !== type do
    {:error, "Mismatch resource type"}
  end

  def create_resource(resourcetype, resource) do
    Logger.info "[FhirService] create resource #{resourcetype}"
    FhirRepo.insert(resource)
  end
end
