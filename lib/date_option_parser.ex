defmodule WeeklySummary.DateOptionParser do
  def calculate_date_range(options, now \\ Timex.now)

  def calculate_date_range([num_days: num_days], now) when is_integer(num_days) do
    end_date = now |> Timex.beginning_of_day
    start_date = end_date |> Timex.shift(days: -num_days)

    %{
      start_date: start_date,
      end_date: end_date
    }
  end
  def calculate_date_range([], now) do
    end_date = now |> Timex.beginning_of_day
    start_date = end_date |> Timex.shift(days: -7)

    %{
      start_date: start_date,
      end_date: end_date
    }
  end
end
