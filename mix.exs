defmodule Fernet.Ecto.Mixfile do
  use Mix.Project

  @version "2.0.0-rc.0"

  def project do
    [
      app: :fernet_ecto,
      description: "Fernet-encrypted fields for Ecto",
      package: package(),
      version: @version,
      name: "fernet-ecto",
      homepage_url: "https://github.com/jkakar/fernet-ecto",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      docs: [
        source_ref: "v#{@version}",
        main: "Fernet.Ecto",
        source_url: "https://github.com/jkakar/fernet-ecto"
      ],
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger, :crypto]]
  end

  defp deps do
    [
      {:earmark, "~> 1.4", only: [:dev]},
      {:ex_doc, "~> 0.34", only: [:dev]},
      {:ecto, "~> 3.0"},
      {:fernetex, "~> 0.5.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Jamu Kakar", "Rico Moorman"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/jkakar/fernet-ecto",
        "Docs" => "http://hexdocs.pm/fernet_ecto/#{@version}/"
      }
    ]
  end
end
