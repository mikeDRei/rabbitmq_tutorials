defmodule ReceiveLogs do
  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts " [x] Recebido: #{payload}"

        wait_for_messages(channel)
    end
  end
end

{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
# Fanout: ele apenas transmite todas as mensagens que recebe para todas as filas que conhece.
AMQP.Exchange.declare(channel, "logs", :fanout)
# Criando nomes aleatorios de filas.
{:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)
# Precisamos dizer à exchange para enviar mensagens para nossa fila
# A relação entre a troca e uma fila é chamada de ligação.
AMQP.Queue.bind(channel, queue_name, "logs")
AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)
IO.puts " [*] Waiting for messages. To exit press CTRL+C, CTRL+C"

ReceiveLogs.wait_for_messages(channel)
