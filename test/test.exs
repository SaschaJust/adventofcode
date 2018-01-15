result =
  1..25
  |> Enum.map(fn x -> x
    |> Integer.to_string
    |> String.pad_leading(2, "00")
    |> (&{
      &1,
      Task.async(fn -> start = Time.utc_now; {result, _} = System.cmd("elixir", ["day_#{&1}/elixir/day_#{&1}.exs"]); {result, Time.diff(Time.utc_now, start)} end),
      ({:ok, input} = File.read "results/day_#{&1}.expected"; input),
      }).()
  end)
  |> Enum.map(fn {test,execution,expected} ->
    {result, time} = Task.await(execution, 60_000)
    cond do
      result == expected -> IO.puts "Test #{test} passed in #{time} seconds."; 0
      true -> IO.puts "Test #{test} failed in #{time} seconds: +#{inspect result}\n-#{inspect expected}"; 1
    end
  end)
  |> Enum.sum

System.halt(result)
