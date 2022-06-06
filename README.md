# RabbitmqTutorials

# RabbitmqTest

## Installation

[first install rabbitmq](https://www.hackerxone.com/2021/08/24/steps-to-install-rabbitmq-on-ubuntu-20-04/), 
[install asdf](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies),
[asdf install erlang and elixir](https://www.pluralsight.com/guides/installing-elixir-erlang-with-asdf)
  the package can be installed
by adding `amqp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:amqp, "~> 1.0"},
  ]
end
```
This tutorial assumes RabbitMQ is installed and running on localhost on the standard port (5672).

inside the project folder run:

```bash
mix deps.get
mix deps.compile
```
## [1 "Hello World!"](https://www.hackerxone.com/2021/08/24/steps-to-install-rabbitmq-on-ubuntu-20-04/)
```bash
mix run introduction/send.exs

```

```bash
mix run introduction/receive.exs

```

## [2 Work queues!](https://www.rabbitmq.com/tutorials/tutorial-two-elixir.html/)
```bash
mix run work_queues/new_task.exs Hello!!

```

```bash
mix run work_queues/worker.exs

```

## [3 Publish/Subscribe](https://www.rabbitmq.com/tutorials/tutorial-three-elixir.html)
```bash
mix run publish_subscribe/emit_logs.exs

```

```bash
mix run publish_subscribe/receive_logs.exs

```

## [4 Routing](https://www.rabbitmq.com/tutorials/tutorial-four-elixir.html)
```bash
mix run routing/emit_logs_direct.exs --warning --error error_message

```

```bash
mix run routing/receive_logs_direct.exs --error --warning

```

## [5 Topics](https://www.rabbitmq.com/tutorials/tutorial-five-elixir.html)
```bash
mix run topics/emit_logs_topic.exs "log.error" Erro de log

```

```bash
mix run topics/receive_logs_topic.exs "*.error"
mix run topics/receive_logs_topic.exs "#"

```

## [6 RPC](https://www.rabbitmq.com/tutorials/tutorial-six-elixir.html)
```bash
mix run rpc/rpc_client.exs 14

```

```bash
mix run rpc/rpc_server.exs

```
