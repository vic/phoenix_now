# Example Phoenix deployment on Zeit Now.

This is an example project showing how to build a phoenix app with docker and publish it on Zeit.

# Usage (Adapting for your application)

### Distillery

Add a dependency on your `mix.exs` file for [distillery](https://hexdocs.pm/distillery/getting-started.html) 
Setup your `rel/config.exs` file.

### Review elixir version

Check on `Dockerfile*` for the correct elixir version to be used during build.

### Adapt your project 

- Copy this project's `docker_build` task

### Build the image using docker

Building the release inside docker is important if you want to include the ERTS (erlang runtime)
as the binary needs to be created for the target platform.

```shell
mix docker.build
```

### Upload to Zeit using `now`

```shell
now
```

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
