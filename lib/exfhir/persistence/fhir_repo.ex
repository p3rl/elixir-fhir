defmodule ExFhir.FhirRepo do

  def get_all(resourcetype) do
    GenServer.call :fhir_repo, {:get_all, resourcetype}
  end

  def insert(resource) do
    GenServer.call :fhir_repo, {:insert, resource}
  end

end
