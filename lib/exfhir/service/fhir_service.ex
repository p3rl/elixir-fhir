defmodule ExFhir.FhirService do
  require Logger

  def get_all(resource_type) do
    Logger.info "[FhirService] get all (#{resource_type})"
    %{"resourceType" => resource_type}
  end

  def get_resource(resource_type, id) do
    Logger.info "[FhirService] get resource (#{resource_type}, #{id})"
    %{"resourceType" => resource_type, "id" => id}
  end

  def get_resource_version(resource_type, id, version) do
    Logger.info "[FhirService] get resource version (#{resource_type}, #{id}, #{version})"
    %{"resourceType" => resource_type, "id" => id, "version" => version}
  end

end
