defmodule RabbitmqTutorials.MixProject do
  use Mix.Project

  def project do
    [
      app: :rabbitmq_tutorials,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:lager, :logger, :amqp]
    ]
  end

  defp deps do
    [
      {:amqp, "~> 1.0"},
    ]
  end
end
