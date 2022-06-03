defmodule Worker do
  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        IO.puts " [x] Recebido: #{payload}"
        payload
        |> to_char_list
        |> Enum.count(fn x -> x == ?. end)
        |> Kernel.*(1000)
        |> :timer.sleep

        AMQP.Basic.ack(channel, meta.delivery_tag)

        wait_for_messages(channel)
    end
  end
end

{ :ok , connection} = AMQP.Connection.open 
{ :ok , channel} = AMQP.Channel.open(connection)

AMQP.Queue.declare(channel, "task_queue")
AMQP.Basic.qos(channel, prefetch_count: 1)

AMQP.Basic.consume(channel, "task_queue")
IO.puts " [*] Aguardando mensagens. Para sair pressione CTRL+C, CTRL+C" 

Worker.wait_for_messages(channel)

