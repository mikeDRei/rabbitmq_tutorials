defmodule EmitLogs do
  def send_message() do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    log = IO.gets("Digite o log... ")
    message =
      case System.argv do
      []    -> "#{log}"
      words -> Enum.join(words, " ")
      end
# Existem alguns tipos de troca disponíveis: direct , topic , headers e fanout.
# Fanout: transmite todas as mensagens que recebe para todas as filas que conhece 
    AMQP.Exchange.declare(channel, "logs", :fanout)
# logs é o nome da troca (exchange)
    AMQP.Basic.publish(channel, "logs", "", message)
    IO.puts " [x] Enviado '#{message}'"

    AMQP.Connection.close(connection)
    send_message()
  end
end
EmitLogs.send_message()
