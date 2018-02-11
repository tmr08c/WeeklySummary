defmodule WeeklySummary.DateOptionParserTest do
  use ExUnit.Case, async: true

  describe "calculate_date_range/2" do
    test "defaults to using 7 days" do
      %{start_date: start_date, end_date: end_date} =
        WeeklySummary.DateOptionParser.calculate_date_range([], Timex.to_datetime({2018,1,10}))

      assert(start_date == Timex.to_datetime({2018,1,3}))
      assert(end_date == Timex.to_datetime({2018,1,10}))
    end

    test " uses beginning of day" do
      %{start_date: start_date, end_date: end_date} =
        WeeklySummary.DateOptionParser.calculate_date_range([], Timex.to_datetime({{2018,1,10},{13,12,11}}))

      assert(start_date == Timex.to_datetime({{2018,1,3},{0,0,0}}))
      assert(end_date == Timex.to_datetime({{2018,1,10},{0,0,0}}))
    end

    test "num_days option go num_days back until today" do
      %{start_date: start_date, end_date: end_date} =
        WeeklySummary.DateOptionParser.calculate_date_range([num_days: 9], Timex.to_datetime({{2018,1,10},{13,12,11}}))

      assert(start_date == Timex.to_datetime({{2018,1,1},{0,0,0}}))
      assert(end_date == Timex.to_datetime({{2018,1,10},{0,0,0}}))
    end
  end
end
