defmodule Q11 do
  def solve do
    data = parseData()

    empty_state =
      "LLLLLLLL.LLL.LLLLLLLLLLLLL.LL.LLLLLL.LL.LLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLLL.LLLLLLLL "
      |> String.replace("L", ".")
      |> String.duplicate(length(data))
      |> String.split()

    final_state = doUntilStable(data, 0, 0, empty_state, 0, empty_state)

    final_state |> List.to_string() |> String.graphemes() |> Enum.frequencies() |> Map.get("#")
  end

  def doUntilStable(data, start_row, start_col, template, count, old_state) do
    if !checkIsSame(data, old_state) do
      IO.inspect(data)
      state = checkSeats(data, start_row, start_col, template)
      doUntilStable(state, start_row, start_col, template, count + 1, data)
    else
      data
    end
  end

  def checkSeats(data, row_num, col_num, new_state) do
    if row_num < length(data) do
      curr_tile = data |> Enum.at(row_num) |> String.at(col_num)
      bool_list = checkAllAdjecent(data, row_num, col_num)
      freq = Enum.frequencies(bool_list)

      cond do
        curr_tile == "L" && Enum.all?(bool_list) ->
          changed_state = replaceSeat(row_num, col_num, new_state, "#")

          if col_num == String.length(Enum.at(data, row_num)) - 1 do
            checkSeats(data, row_num + 1, 0, changed_state)
          else
            checkSeats(data, row_num, col_num + 1, changed_state)
          end

        curr_tile == "#" && Map.get_lazy(freq, false, fn -> 0 end) > 4 ->
          changed_state = replaceSeat(row_num, col_num, new_state, "L")

          if col_num == String.length(Enum.at(data, row_num)) - 1 do
            checkSeats(data, row_num + 1, 0, changed_state)
          else
            checkSeats(data, row_num, col_num + 1, changed_state)
          end

        curr_tile == "#" ->
          changed_state = replaceSeat(row_num, col_num, new_state, "#")

          if col_num == String.length(Enum.at(data, row_num)) - 1 do
            checkSeats(data, row_num + 1, 0, changed_state)
          else
            checkSeats(data, row_num, col_num + 1, changed_state)
          end

        curr_tile == "L" ->
          changed_state = replaceSeat(row_num, col_num, new_state, "L")

          if col_num == String.length(Enum.at(data, row_num)) - 1 do
            checkSeats(data, row_num + 1, 0, changed_state)
          else
            checkSeats(data, row_num, col_num + 1, changed_state)
          end

        curr_tile == "." ->
          if col_num == String.length(Enum.at(data, row_num)) - 1 do
            checkSeats(data, row_num + 1, 0, new_state)
          else
            checkSeats(data, row_num, col_num + 1, new_state)
          end
      end
    else
      new_state
    end
  end

  def replaceSeat(row_num, col_num, new_data, new_seat_state) do
    new_row =
      new_data
      |> Enum.at(row_num)
      |> String.graphemes()
      |> List.replace_at(col_num, new_seat_state)
      |> List.to_string()

    List.replace_at(new_data, row_num, new_row)
  end

  def checkIsSame(data, old_data) do
    List.to_string(data) === List.to_string(old_data)
  end

  def checkAllAdjecent(data, row, col) do
    [
      checkUp(data, row, col),
      checkDown(data, row, col),
      checkLeft(data, row, col),
      checkRight(data, row, col),
      checkRightUp(data, row, col),
      checkRightDown(data, row, col),
      checkLeftUp(data, row, col),
      checkLeftDown(data, row, col)
    ]
  end

  def checkUp(data, row_num, col_num) do
    cond do
      row_num == 0 ->
        true

      data |> Enum.at(row_num - 1) |> String.at(col_num) == "L" ->
        true

      data |> Enum.at(row_num - 1) |> String.at(col_num) == "#" ->
        false

      data |> Enum.at(row_num - 1) |> String.at(col_num) == "." ->
        checkUp(data, row_num - 1, col_num)

      true ->
        true
    end
  end

  def checkDown(data, row_num, col_num) do
    cond do
      row_num == length(data) - 1 ->
        true

      data |> Enum.at(row_num + 1) |> String.at(col_num) == "L" ->
        true

      data |> Enum.at(row_num + 1) |> String.at(col_num) == "#" ->
        false

      data |> Enum.at(row_num + 1) |> String.at(col_num) == "." ->
        checkDown(data, row_num + 1, col_num)

      true ->
        true
    end
  end

  def checkLeft(data, row_num, col_num) do
    cond do
      col_num == 0 ->
        true

      data |> Enum.at(row_num) |> String.at(col_num - 1) == "L" ->
        true

      data |> Enum.at(row_num) |> String.at(col_num - 1) == "#" ->
        false

      data |> Enum.at(row_num) |> String.at(col_num - 1) == "." ->
        checkLeft(data, row_num, col_num - 1)

      true ->
        true
    end
  end

  def checkRight(data, row_num, col_num) do
    cond do
      col_num == String.length(Enum.at(data, row_num)) ->
        true

      data |> Enum.at(row_num) |> String.at(col_num + 1) == "L" ->
        true

      data |> Enum.at(row_num) |> String.at(col_num + 1) == "#" ->
        false

      data |> Enum.at(row_num) |> String.at(col_num + 1) == "." ->
        checkRight(data, row_num, col_num + 1)

      true ->
        true
    end
  end

  def checkRightUp(data, row_num, col_num) do
    cond do
      row_num == 0 || col_num == String.length(Enum.at(data, row_num)) ->
        true

      data |> Enum.at(row_num - 1) |> String.at(col_num + 1) == "L" ->
        true

      data |> Enum.at(row_num - 1) |> String.at(col_num + 1) == "#" ->
        false

      data |> Enum.at(row_num - 1) |> String.at(col_num + 1) == "." ->
        checkRightUp(data, row_num - 1, col_num + 1)

      true ->
        true
    end
  end

  def checkRightDown(data, row_num, col_num) do
    cond do
      row_num == length(data) - 1 || col_num == String.length(Enum.at(data, row_num)) ->
        true

      data |> Enum.at(row_num + 1) |> String.at(col_num + 1) == "L" ->
        true

      data |> Enum.at(row_num + 1) |> String.at(col_num + 1) == "#" ->
        false

      data |> Enum.at(row_num + 1) |> String.at(col_num + 1) == "." ->
        checkRightDown(data, row_num + 1, col_num + 1)

      true ->
        true
    end
  end

  def checkLeftDown(data, row_num, col_num) do
    cond do
      row_num == length(data) - 1 || col_num == 0 ->
        true

      data |> Enum.at(row_num + 1) |> String.at(col_num - 1) == "L" ->
        true

      data |> Enum.at(row_num + 1) |> String.at(col_num - 1) == "#" ->
        false

      data |> Enum.at(row_num + 1) |> String.at(col_num - 1) == "." ->
        checkLeftDown(data, row_num + 1, col_num - 1)

      true ->
        true
    end
  end

  def checkLeftUp(data, row_num, col_num) do
    cond do
      row_num == 0 || col_num == 0 ->
        true

      data |> Enum.at(row_num - 1) |> String.at(col_num - 1) == "L" ->
        true

      data |> Enum.at(row_num - 1) |> String.at(col_num - 1) == "#" ->
        false

      data |> Enum.at(row_num - 1) |> String.at(col_num - 1) == "." ->
        checkLeftUp(data, row_num - 1, col_num - 1)

      true ->
        true
    end
  end

  def parseData do
    data =
      "LLLLLLLL.LLL.LLLLLLLLLLLLL.LL.LLLLLL.LL.LLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLLL.LLLLLLLL
    LLLLLLLL.LLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLL.LL.LLLLLLL.LLLLLL.LLLLLLLLL.LLLL.LLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LLLL.LLL.LLLLLLLLLLLL.LLL..LLLLLL.LLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LL.L.LLLLLLLLLLLLLLLL..LLLLLLLL.LLLLLLLLLLLLLLLLLLLL.LLLLLLLL.LLLLLLLLLLLLLL
    LLLLLLL.LLLLLLLLLLL.LLLLLLLLL.L.LLLLLLLLLLLLL..LLLLLLL.LLLLLL.LLLLL.LLLLLLLLLLLLLL.LL.LLLLL
    ..L.L...L....L......LL.LLL..L.L.L.L...L.........LLLL..L..L...LL..L.L.L.....LLLLL..L..L..L..
    LLLLLLLL..LLLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLL.LLLLLLLLLLLLLLLL.LLL.LLLLLL.LLLLLLLL
    LLLLLLLLLLLLLLLLLL..LLLLLLLLL.LLLLLLLLLL.LL.LLLLL.LLL..LLLLLLLLLLL..LLLL.LLLLLLLLL.LLLLLLLL
    LLLLLLLLLLLLLL.L.LL.LLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLL.L.LLLLLL.LLLLLLLLLLLLLLLLL.LL.LLLLLLLL
    LLLLLLLL.LLLLL.LLLL.LLLLLLL.L..LLLLLLLLLL.LLLLL.LLLLLL.LLLLLL.L.LLLLLLLLLLLL.LLLLL.LLL.LLLL
    LLL.LLLL.LLLLL.LLLL.LLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLLLLL.LL.LL.LLLLLLLLLLLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LLLLLLLL.LLLLL.LLLLLL.L.LLLLLLL..LLLL.L.LLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLL
    LLLLLLL.LLLLLL.LL.L.LLLLLLLL..LLLLLLLLLLLLL.LLLLLLLLLL.LL.LLL.LLLLL.LLLLLL.L.LLLL..LLLLLLLL
    LLLLLLLL.LLLLL.LLLL..LLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLLL.LLLLLL.LLLLLLLLLLL.LL..LLLL.LLLLLLLL
    LLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLL.LLLLLLL..L.LLLLLLLLLLLL.LLLLL.LLLLLL.L.LLLLL.LLLLLLLL
    .L.LL....LLL..L.......L...LLLL..LLL....L..L...L.....L...L...LL......L.....L......L........L
    LLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLL...LLLLLLLL.LL.LLLL.LLLLL..LLL.L.LLLLLLLL.LLLLLLLLLLLL.L
    LLLLLLLL.LLLL.LLLLL.LLLLLLLLL.LL.L.LLLLLLLLLL..LLLLLLLLLLLLLL.LLLLL.LLLLLLLL.LLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLLLLLL.LLLLLLL.LL.LLL.LLLLLLLLLLLLLL.LLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LLLL.LLLLLLLLL..LLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LL.LLLLLLLL.LL.LLLLL.LLLLLL.L
    .LLLLLLLL.LLLL.LLLL.LLLLLLLLL.L.LLLL.LLLLLLLL..LL.L.LL.LLLLLL.L.LLL.L.LL.LL..LLLLL.LLLLLLLL
    LLLLL.LLLLLLLL.LLLL.LLLLLLLLL.LLLLL.LLLLLLLLLL.LLL.LLLLLLLLLL.LLLLL.LLLLLLLL.LLLLLLLLLL.LLL
    L..L.L..L....L....L.....LL.L.LL.L...L.L.LL..LL.L.....L.L...L....LL.L....LL........L..LL...L
    LLLLLLLL.LLLLL.LLLLLLL.LLLLLL.LLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLL..LLLL.LL.LLLLLLLLLLLLLL
    LLLLLLLL.LLLLL.LLLL.LLLLL.L.LLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLL..LLLLL.LLLLLLLL.LLLL..L.LLLLLL
    LLLLLLLL...LLL.LLLL..LLLLLLL..LLLLLL.L.LLLLLLLLLLL.LLLLLLLLLL.LLLLL.LLLLLLLL.LLLLLLLLLLLLLL
    LLL.LLLL.LLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLLLLL.LLLL.LL.LLLLLLLLLLLL.LLLLLLLL.LLLLL.LLL..LLL
    LLLLLLLLLLLLLL.LLLL.LLLLL.LLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLLLL
    LL.LL.LLLLLLLLLLLLLL.LLLLLLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLLLL
    LLLL.LLL.L.LLL.LLLL.LLLLLLLLL.L.LLLL.LLLLL.LLL.LLLLL.L.LLLLLL.LLLLL.LLLLLLLL.LLLLLLLLLLLLLL
    .L........L...L.....LL..L..L......L.L.LLL.L.LL..LL....LLL..L.L..LLLL...LLLL...L..........LL
    LLLLLLL.LLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLL.LLLLL.LLLL.LLLLLL.LLLLL.LLLLLLLL.LLLLL.LLLLLLL.
    LLLLLLLL.LLLLL..LLL.LLLLLLLLL.LLLLLL.LLLLLLLL..LLLLLLL.LLLLLL.LLLLLLLLLLLLLLLL.LLL.LLLLLLLL
    LLLLLLLL.LLLLLLL.LL.LLLLLLLLLLLLLLLLLLLLLL.LLL.LLLLLLL.LLLLLL.LLLLL.LLLLLLLLL.LLLL.LLLLLLLL
    .LLLLLLL.LLLLL.LLLL.LLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLL.LL.LLL.LLLLLLLLLLLLLLLLLLLL.LLLLLLLL
    LLL.LLLL.LLLLL.LLLL.LLLLLLLLL.LLLLLL.LLLLLLL.L.LLLLLLL.LLLLL...LLLL.LLLLLLLL.LLLLL.LLLLLLLL
    LLLLLLLL.LLL.L.LLLLLLLLLLLLLL.LLLLLLLLLLL.LLLL.LLLLLLL.LLLLLL.LLLLL.LLLLLLLLLL.LLL.LLLLLLLL
    LLLLLLLL.LLLLL.LLLL.L.LLLLLLLLLLLLLL.LLL.LLLLL.LLLL.LL.LLLLLLL.LL.L.LLLLLLLL.LLL.L.LLLLLLLL
    .LLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLLL.L.LLLLLLL.LLLLLL.LLLLL.LLLLLLLLLLLLLLLLLLLLLLL
    LLLLLLLL.LLLLLLLLLL.LLLLLLL.LLL.LLLLLLLLLLLLLLLLLLL.LL.LLLLLLLLLLLL.LLLL.LLL.LL.LL.LLLLLLLL
    .L....L........L.L.L......LL..L.L.L...LLLL.....L...L..........LL.LLLL.L...L.L.LL.LL.L...L.L
    LLLLLLLL.LLLL.LLL.L..L.LLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.L.LLLLLLLLLLLLLLLLLLLL.LLLLLLLL
    LLLL.LLL.LLLL..LLLL.LL.LLLL.LLLLLLLL.LLL.LLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLL..LLLL.LLL.LLLLL
    LLLLLLLL..LLLLLL.LL.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLL.LLLLLL.LLLLL.LLLL.LLL.LLLLL.LLLLLLLL
    LLLLLLLLLLLLLLL.LLLLLLLLLLLLL.LLLLLLLLLLLLL.LLLLLLLLLL.LLL.LL..LLLLLLLLLLLLL.LLL.L.LL.L.LLL
    LLLLLLLLLLLLL..LL.LLLLLLLLLLLLLLLLLL.LLLLLLLLL.LLLLLLL.LLLLLL.LLLLL.LLLLLLLL.LLLLLLLLLLLLLL
    LLL.LLLL.LLLLL.LLLL..LLLLL.LLLLLLLLL.LLLL..LLLLLLLLLL..LLLLLLLLLLLL.LLLLLLLLLLLLLL.LLL.LLLL
    LLLLLLLL.LLLLL.LLLL.LLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLL.LLLLLLLL
    L.L.LLLL.LLLLL.LL.L.LLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLL.LLLLLLLLL.LLL.LLLLLLLLLLLLLLLLLLLLLL
    ..LLLL.........L.LL.LL....L.LL...LLLL....L...L........LL...L.L......L.LLL.L.L...LL....L...L
    LLLLLLLL.LL.LL.LLLL.LLLL.LLLLLLL.LLL.LLLLLLLLL.LLLLLL.LLLLLL..LLLLL.LLLLL.LLLLLLLLLLLLLLLLL
    LLLLLL.LLLLLLL.LLLL.LLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL..LLLLLL.L.L.L.LLL.LLLLLLLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LL.L.LLLLLLLLLLLLLLLLLLLLLLLL.L.LLLL.LL.LLLLLL.LLLLL.LLLLLLLL..LLLL.LLLLLLLL
    LLLLL.LL.LLLLL.LLLLLLLLLLLLLLLLLLLLL.L.LLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLLLLLL
    LLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLL.LLLLLL.LLLL.LLLLL..LLLLL.L.LLLLLL.LLLLL.LLLLLLLL
    LLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLL.LLLLLLLLLLLLLL.LLLL.LLL
    LLLLLLLL.LLLLL.LLLL.LLLLLLLLL.LLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLLL
    L.....LL..L..L.L..L....L.L......LL..L......L.LL..L..L..L...L..L...L.....L......LLLLLL......
    LLLLL.LLLLLLLLLLLLL.LLLLLLLLLLLLLLLL..LLLLLLLLLLLLLLLL.LLLLL.L.LLLL.LLLLLLLL.LLLLL.LLLLLLL.
    LLLLLLLL.LLLLL.LLLL.LLLLLL.LL.LLLLLL.LLLLLLLLL.LLLLL.L.LLLLLL.LLLLL.LLLL.LLL.LLLLLLLLLLLLL.
    LL.LLLLL.LLLLL.LLLL.LLLLLLLLLL.LLLLLLLLLLLLLLL.LLLLLLL..LLLLLLLLLLLLLLLLLLLL.LLLLL.LLLLLLLL
    .LLLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLL.LLLLLL.LLLLL.LLLLLLLL.LLLLLLLLLLLLLL
    L....L.LL.LLL.L...LL.L....LL..........L.L..L.....LL...L.....LL......L...LLLL.L.....L.LL.L..
    LLLLLLLL.LLL.LLLL.L.LLLLLL.LL.LLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLLLLLLLLLLLL.LLLLL.LLL.LLLL
    LL.LLLL..LLLLL..LLL.LLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLL..LLLLLLLLLLLL.LLLLLLLL.LLLLL.LLLL.LLL
    LLLLLL.L.LLL.L.L.LL.LLLLLLLLLLLLLLLL.LLLL.LLLL.L..L.LL.LLLLLL.LLLLLL.LLLLLLL.LLLLL..LLLL.LL
    LLLLLLLL.LLLLL.LLLLLLLLLLLLLLLLLLLLL..LLLLLLLL...LLLLLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLL
    LLLLLLLL.LLLLL.LL.L.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLL.LLL.LLLLL.LLLLLLL..LLLLL.LLLLLLLL
    LLLLLL.LLLLLLL..LLLLLLLLLL.LLLLLLLLL.LLLLLL.LL.LLLLLLL.LLLLLL.LLLLLLLLLL.LLLLLLLLLL.LLLLLLL
    L......L....L...L..L...L..L.LLL.LLLL....L...L.L.L....L..L...LLL.LLL...L......LL....L...L.LL
    LLLLLLLL.LLLLL.LLL..LL.LLLLLLLLLLLLL.LLLLLLLLL.LLLLLLLLLLLLL..L.LLLLLLLLLL.LLLLLLLL.LLLLLLL
    LLLLLLLL.LLLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLLLL
    LLLLLLLL.LLLLL.LLLL.LLLLLLLLLLLL.LLLLLLLLLLLLL.LLLLLLL.LLLLLL.LLLLLLLLLLLLLLLLLLL..LLLLLLLL
    LLLLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLL.LLLLLLLLLLLLLLLLL.LLLLLLLLLLLL.LLLLLLLL.LLLLL.LLLLLLLL
    LLLL.LLL.LLLL..LLLL.L.L.LLLLL.LL.L.L.LLLLLLLLL.LLLLLLLLLLLLLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLLL
    LLLLLLLLLLLLLLLLLL..L.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLLL.LLLLLLLLLLLL.LLLLLLLLLLLLLLL.LLLLLLL
    LL.LLLLL.LLLLL.LLLL.LLLLLLLLLLLLLLLLLLLLLLLL.LL.LLLLLLLLLLLL..LLLLL.LLLLLLLL.LLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LLLLLLLLLLLLLL.LLLLLL.LLLLLLLLL.LLLLLLL.LLLLLLLLLLLLLLLLLL.LL.LLLLL.LLLLLLLL
    LLLLLLLL.LLLLL.LLL.LLLLLLLLLL.LLLLLLLLLLLLLLL..LLLLLLL.LLLLLL.LLLLL.LLLLLLLL.LLLLL.LLLLLLLL
    .LLL.L..L...L.L...L...LL.L..LL.L...LLL.L.L...L...L.LLL..L.......L....L..L......LL..........
    LLLLLLLL.LLLLL.LLLL.LL.LLLLLLLLLLLLL.LLLLLLLLL.L.LLLLL.LLLLLL.LLLLL.LLLLLLLL.LLLLL.LLLLLLLL
    LLLLLLLL.LLLLLLLL.LLLLLLLLLLL.LLLLLLLLLLLLLLLL.LLLLLLL.LLLLLL.LLLLLLLLLLLLLL.LLLL..LLLL.LL.
    LLLLLLLL.L.LLLLLLLLLLLLLLLLLLLLL.LLL..LLLLLLLL.LLLLLLL.LLL.LLLLLLLL.LLLLLLLL.LLLL..LLLLLLLL
    LLLLLLLL.LLLLL.LLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLL.LL.LLLLLLLLLLLLLLLLLLL.L..LLLL.LLLLLLLL
    LLL.LLLL.LLLLL.LLLL.LLLLLLL.LLLLLLLL.LL.LLLLLL.LLLLLLL.LLLLLL.LLLLL.LLLLLL.L.LLLLLLLLLLLLLL
    LL.LLLLL.L.LLL.LLLL.L.LLLLLLLLLLLLLL..LLLLLLLL.LLLLLLL.L.LLLL.LLL.L.LLLLLLLLLLLLLL.LLLLLLLL
    LLLLLLLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLLL.LLLLLL.LLLLLLLLLLLLLL.LLLLL.LLLLLLLLLLLLLLLLLLLLLLL
    LL.LLLLL.LL.LLLLLLL.LLLLLLLLL.LLLL.L.LLLLLLLLL.LLLLLLL..LLLLL.LLLLL.LLLLLLLLLLLLLL.LLL.LLLL
    LLLLLLLL.LLLLLLLLLL.LLLLLLLLL.LLLL.L.LLLLLLLLL.LLLL.LLLLLLLLL.LLLL.LLLLLLLLL.LLLLLLLLLLLLLL"

    String.split(data)
  end
end
