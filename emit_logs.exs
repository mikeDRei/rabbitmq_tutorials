{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

log = IO.gets("Digite o log... ")
message =
  case System.argv do
    []    -> "#{log}"
    words -> Enum.join(words, " ")
  end

AMQP.Exchange.declare(channel, "logs", :fanout)
AMQP.Basic.publish(channel, "logs", "", message)
IO.puts " [x] Enviado '#{message}'"

AMQP.Connection.close(connection)
