defmodule ExFhir.FhirRepository do

  def get_all(resourcetype) do
    GenServer.call :fhir_repo, {:get_all, resourcetype}
  end

  def insert(resource_base_content, resource) do
    GenServer.call :fhir_repo, {:insert, resource_base_content, resource}
  end

end
