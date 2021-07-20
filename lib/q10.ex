defmodule Q10 do
  def solve do
    all_adapters = parseData()

    max = getDeviceJolt(all_adapters)

    getAllDiffs(all_adapters, 0, max, [])

  end

  def getAllDiffs(data, rating, max_rating, diffs) do
    cond do
      rating == max_rating ->
        freq = Enum.frequencies(diffs)
        freq[1] * freq[3]
      true ->
        new_rating = findAdapter(data, rating)
        calc_diff = new_rating - rating
        getAllDiffs(data, new_rating, max_rating, diffs ++ [calc_diff])
    end
  end


  def findAdapter(data, rating) do
    if rating != Enum.max(data) do
      Enum.min(Enum.filter(data, fn d ->
        filter = [rating + 1, rating + 2, rating + 3]
        Enum.member?(filter, d)
      end))
    else
      rating + 3
    end
  end

  def getDeviceJolt(data) do
    Enum.max(data) + 3
  end
  def parseData do
    data = "126
    38
    162
    123
    137
    97
    92
    67
    136
    37
    146
    2
    139
    74
    101
    163
    128
    127
    13
    111
    30
    117
    3
    93
    29
    152
    80
    21
    7
    54
    69
    40
    48
    104
    110
    142
    57
    116
    31
    70
    28
    151
    108
    20
    157
    121
    47
    75
    94
    39
    73
    77
    129
    41
    24
    44
    132
    87
    114
    58
    64
    4
    10
    19
    138
    45
    76
    147
    59
    155
    156
    83
    118
    109
    107
    160
    61
    91
    102
    115
    68
    150
    34
    16
    27
    135
    161
    46
    122
    90
    1
    164
    100
    103
    84
    145
    51
    60"

    data |> String.split() |> Enum.reduce([], fn num, acc -> acc ++ [String.to_integer(num)] end)
  end
end
