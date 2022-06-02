#Conexão com ampq
{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
#Criando fila
AMQP.Queue.declare(channel, "fila")
#Recebendo mensagem
message = IO.gets("Digite sua mensagem... ")
#Enviando mensagem para a fila
AMQP.Basic.publish(channel, "", "fila", message)
IO.puts " [x] Enviado "
AMQP.Connection.close(connection)
