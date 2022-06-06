{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

message =
  case System.argv do
    []    -> "Olá mundo!!"
    words -> Enum.join(words, " ")
  end
# A principal ideia por trás do Work Queues é evitar fazer uma tarefa com muitos 
# Recursos imediatamente e ter que esperar que ela seja concluída. 
# (persistent: true) fila task_queue não será perdida mesmo se o RabbitMQ for reiniciado
AMQP.Basic.publish(channel, "", "task_queue", message, persistent: true)
IO.puts " [x] Enviado '#{message}'"
