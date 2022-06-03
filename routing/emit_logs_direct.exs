{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

IO.puts("basta digitar o tipo de log (--info --warning ou --error) e a mensagem que deseja enviar!")
# recebendo o tipo da mensagem quando o arquivo é executado para filtrar as mensagens que serão emitidas
{severities, raw_message, _} =
  System.argv
  |> OptionParser.parse(strict: [info: :boolean, warning: :boolean, error: :boolean])
  |> case do
    {[], msg, _} -> {[info: true], msg, []}
    other -> other
  end

message =
  case raw_message do
    []    -> "Olá mundo!!"
    words -> Enum.join(words, " ")
  end

AMQP.Exchange.declare(channel, "direct_logs", :direct)
# a gravidade (serverity) da mensagem, serve como filtro para o operador (receive_logs)
for {severity, true} <- severities do
  severity = severity |> to_string
  AMQP.Basic.publish(channel, "direct_logs", severity, message)
  IO.puts " [x] Enviado - gravidade da mensagem: '[#{severity}] mensagem: #{message}'"
end

AMQP.Connection.close(connection)
