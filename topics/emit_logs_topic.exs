{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

{topic, message} =
  System.argv
  |> case do
    []            -> {"informacao.anonima", "use: mix run emit_logs_topic.exs [chave de roteamento] [mensagem]"}
    [message]     -> {"informacao.anonima", message}
    [topic|words] -> {topic, Enum.join(words, " ")}
  end

AMQP.Exchange.declare(channel, "topic_logs", :topic)

AMQP.Basic.publish(channel, "topic_logs", topic, message)
IO.puts " [x] Enviado '[#{topic}] #{message}'"

AMQP.Connection.close(connection)
