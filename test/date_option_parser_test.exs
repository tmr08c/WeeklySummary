defmodule WeeklySummary.DateOptionParserTest do
  use ExUnit.Case, async: true

  describe "calculate_date_range/2" do
    test "defaults to using 7 days" do
      %{start_date: start_date, end_date: end_date} =
        WeeklySummary.DateOptionParser.calculate_date_range([], Timex.to_datetime({2018,1,10}))

      assert(Timex.equal?(start_date, Timex.to_datetime({2018,1,3})))
      assert(Timex.equal?(end_date, Timex.to_datetime({2018,1,10})))
    end

    test " uses beginning of day" do
      %{start_date: start_date, end_date: end_date} =
        WeeklySummary.DateOptionParser.calculate_date_range([], Timex.to_datetime({{2018,1,10},{13,12,11}}))

      assert(Timex.equal?(start_date, Timex.to_datetime({{2018,1,3},{0,0,0}})))
      assert(Timex.equal?(end_date, Timex.to_datetime({{2018,1,10},{0,0,0}})))
    end

    test "num_days option go num_days back until today" do
      %{start_date: start_date, end_date: end_date} =
        WeeklySummary.DateOptionParser.calculate_date_range([num_days: 9], Timex.to_datetime({{2018,1,10},{13,12,11}}))

      assert(Timex.equal?(start_date, Timex.to_datetime({{2018,1,1},{0,0,0}})))
      assert(Timex.equal?(end_date, Timex.to_datetime({{2018,1,10},{0,0,0}})))
    end

    test "start_date with no end dates go until today" do
      %{start_date: start_date, end_date: end_date} =
        WeeklySummary.DateOptionParser.calculate_date_range(
          [start_date: "20171225"],
          Timex.to_datetime({{2018,1,10},{13,12,11}})
        )

      assert(Timex.equal?(start_date, Timex.to_datetime({{2017,12,25},{0,0,0}})))
      assert(Timex.equal?(end_date, Timex.to_datetime({{2018,1,10},{0,0,0}})))
    end

    test "can pass in start and end dates" do
      %{start_date: start_date, end_date: end_date} =
        WeeklySummary.DateOptionParser.calculate_date_range(
          [start_date: "20170101", end_date: "20180101"],
          Timex.to_datetime({{2018,1,10},{13,12,11}})
        )

      assert(Timex.equal?(start_date, Timex.to_datetime({{2017,1,1},{0,0,0}})))
      assert(Timex.equal?(end_date, Timex.to_datetime({{2018,1,1},{0,0,0}})))
    end
  end
end
