defmodule ExFhir.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", ExFhir do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ExFhir do
    pipe_through :api
    get "/:resource_type", FhirController, :get_resources
    get "/:resource_type/:id", FhirController, :get_resource_instance
    get "/:resource_type/:id/_history/:version", FhirController, :get_resource_instance_version
  end
end
