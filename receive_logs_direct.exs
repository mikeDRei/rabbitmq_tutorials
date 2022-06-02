# O algoritmo de roteamento por trás de uma troca direta é simples .
# uma mensagem vai para as filas cuja chave de ligação corresponde exatamente à chave de roteamento.
defmodule ReceiveLogsDirect do
  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        IO.puts " [x] Recebido - gravidade: [#{meta.routing_key}] mensagem: #{payload}"

        wait_for_messages(channel)
    end
  end
end

{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
# recebendo o tipo da mensagem e conteudo para filtrar as mensagens que serão recebidas
{severities, _, _} =
  System.argv
  |> OptionParser.parse(strict: [info: :boolean, warning: :boolean, error: :boolean])

AMQP.Exchange.declare(channel, "direct_logs", :direct)

{:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)

for {severity, true} <- severities do
  binding_key = severity |> to_string
  AMQP.Queue.bind(channel, queue_name, "direct_logs", routing_key: binding_key)
end

AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)

IO.puts " [*] Aguardando mensagens. Para sair pressione CTRL+C, CTRL+C"

ReceiveLogsDirect.wait_for_messages(channel)
