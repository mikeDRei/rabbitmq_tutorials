defmodule FibonacciRpcClient do
  def wait_for_messages(_channel, correlation_id) do
    receive do
# O cliente aguarda dados na fila de retorno de chamada. Quando uma mensagem aparece,
# ela verifica a propriedade correlação_id . Se corresponder ao valor da solicitação,
# ele retornará a resposta ao aplicativo.
      {:basic_deliver, payload, %{correlation_id: ^correlation_id}} ->
        {n, _} = Integer.parse(payload)
        n
    end
  end
  def call(n) do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)
# quando o Cliente é inicializado, ele cria uma fila de retorno de chamada exclusiva anônima.
    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)

    AMQP.Basic.consume(channel, queue_name, nil, no_ack: true)
    correlation_id =
      :erlang.unique_integer
      |> :erlang.integer_to_binary
      |> Base.encode64

    request = to_string(n)
# para uma solicitação RPC, o Cliente envia uma mensagem com duas propriedades: 
# reply_to , que é definida como a fila de retorno de chamada e correlação_id , 
# que é definida como um valor exclusivo para cada solicitação.
    AMQP.Basic.publish(channel, "", "rpc_queue", request, reply_to: queue_name,correlation_id: correlation_id)

    FibonacciRpcClient.wait_for_messages(channel, correlation_id)
  end
end

num =
  case System.argv do
    []    -> 30
    param ->
      {x, _} =
        param
        |> Enum.join(" ")
        |> Integer.parse
      x
  end

IO.puts " [x] Requesting fib(#{num})"
response = FibonacciRpcClient.call(num)
IO.puts " [.] Got #{response}"
