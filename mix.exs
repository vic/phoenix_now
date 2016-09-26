defmodule Now.Mixfile do
  use Mix.Project

  def project do
    [app: :now,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Now, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:distillery, "~> 0.9.9", app: false}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"],
     "docker.build": &docker_build/1 ]
  end

  # Shamefuly stolen from https://github.com/merqlove/elixir-docker-compose/blob/master/release.sh
  defp docker_build(_) do
    {app, version} = {project[:app], project[:version]}

    bin = "docker-#{app}-#{version}"
    vol = "docker_build_#{app}"
    tag = "rel-#{app}:#{version}"

    # create a volume
    0 = Mix.shell.cmd ~s(docker rm -f #{vol} 2>/dev/null || true)
    0 = Mix.shell.cmd ~s(docker create -v /build/deps -v /build/_build -v /build/rel -v /root/.cache/rebar3/ --name #{vol} busybox /bin/true)

    # build the docker image for creating the release
    0 = Mix.shell.cmd ~s(docker build -f Dockerfile.build . --tag "#{tag}")
    0 = Mix.shell.cmd(~s"""
    docker run
       --volumes-from #{vol}
       --rm -t #{tag}
       sh -c "cp config.exs rel/config.exs &&
              mix do deps.get, compile, release --env=prod"
    """ |> String.replace("\n", " "))

    # finally copy the release to build host
    File.mkdir_p "rel/#{app}/bin"
    0 = Mix.shell.cmd ~s(docker cp #{vol}:/build/rel/#{app}/bin/#{app} rel/#{app}/bin/#{bin})

    # and remove the volume
    0 = Mix.shell.cmd ~s(docker rm -f #{vol} 2>/dev/null || true)
    0 = Mix.shell.cmd ~s(docker rmi #{tag})

    :ok
  end

end
