defmodule Receive do
# Aguardando a mensagem 
# Sempre que a biblioteca cliente recebe uma entrega do RabbitMQ, 
# Uma mensagem Elixir {:basic_deliver, payload, metadata} é enviada para o processo Elixir especificado. 
  def wait_for_messages do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts " [x] Recebido: #{payload}"
        wait_for_messages()
    end
  end
end

{ :ok , connection} = AMQP.Connection.open 
{ :ok , channel} = AMQP.Channel.open(connection)
AMQP.Queue.declare(channel, "fila")
AMQP.Basic.consume(channel, "fila", nil, no_ack: true)
IO.puts " [*] Aguardando mensagens. Para sair pressione CTRL+C, CTRL+C" 
Receive.wait_for_messages()
