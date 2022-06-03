{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

text = IO.gets("Digite sua mensagem... ")
message =
  case System.argv do
    []    -> "#{text}"
    words -> Enum.join(words, " ")
  end

AMQP.Basic.publish(channel, "", "task_queue", message, persistent: true)
IO.puts " [x] Enviado '#{message}'"
