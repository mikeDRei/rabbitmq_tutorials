{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

{topic, message} =
  System.argv
  |> case do
    []            -> {"anonymous.info", "Hello World!"}
    [message]     -> {"anonymous.info", message}
    [topic|words] -> {topic, Enum.join(words, " ")}
  end

# Quando uma fila é vinculada com a chave de ligação " # " (hash) - ela receberá 
# Todas as mensagens, independentemente da chave de roteamento - como na troca de fanout.
# Quando os caracteres especiais " * " (estrela) e " # " (hash) não são usados 
# ​​em ligações, a troca de tópicos se comportará como uma direta.
AMQP.Exchange.declare(channel, "topic_logs", :topic)

AMQP.Basic.publish(channel, "topic_logs", topic, message)
IO.puts " [x] Sent '[#{topic}] #{message}'"

AMQP.Connection.close(connection)
