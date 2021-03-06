defmodule Q3 do

  def solve do
    configs = [%{right: 1, down: 1}, %{right: 3, down: 1}, %{right: 5, down: 1}, %{right: 7, down: 1}, %{right: 1, down: 2}]


   Enum.reduce(configs, 1, fn conf, acc -> acc * traverseMap(conf) end)

    #traverseMap(Enum.at(configs,1))
  end

  def traverseMap(config) do
    map = parseMap()
    right_amount = config.right
    down_amount = config.down

    map_length = map |> Enum.count()
    #each new position is going to be 3*rownumber

    tree_count =  for i <- 1..map_length do
                    i_ = i * down_amount
                    if i_ < map_length do
                      row = map |> Enum.at(i_)
                      pos = i*right_amount
                      #IO.inspect("Row num_ "<>to_string(i_)<>" "<>"Real pos: "<>to_string(getRealPos(row,pos)))
                      isTreeAtPos(row, pos)
                    else
                      nil
                    end
                  end

    freq = tree_count |> Enum.frequencies()
    IO.inspect(freq.true)
    end

  def getRealPos(mapbit, pos) do
    length = String.length(mapbit)
    if pos > length do
      rem(pos, length)
    else
      pos
    end
  end

  def isTreeAtPos(mapbit, pos) do
    tree = "#"
    real_pos = getRealPos(mapbit, pos)

    String.at(mapbit, real_pos) === tree
  end

  def parseMap do
    map = "
....#...............#.#..###.##
.#..#....###..............##...
....###......#....#.#...#.##..#
.......#........#..###...##....
.....#..#......#..#..##..#...#.
....#..........#....#...#......
............###...#............
##......#.....#......#.....##..
........#.........##..#.#...##.
....#.#..#.#...#........#..#...
.#.....#.#......#....#..#..#..#
#.##..##......#.....##...#..#..
#........#..##...###....##.....
......#.#..##...#.#.....#......
##.......#..#.........#...#....
.....##.........#....#.#.###.#.
..##...........#.#.#.#.....#.#.
....#...............#......#.#.
#.#..#....#.....#.....##...#..#
#......#..............#.#.##...
......###.....#...#........###.
####...#.....#...#....#........
.......#...#....##...#.........
.####..##............#.........
#.#...#...#....#...#.#......#..
..#..#.....#.......#...#.#...##
.#.........#...#......##.#...#.
.#.#...#...#.....#.#........#.#
.#.....###....###..##.#..##.#..
.....##....#......#..#...#...#.
#...##....#.......#.....##.##..
#...#.....#.#...........#..###.
##.#........###...........###.#
#...#.#........#.#.....#.......
..................#..#.........
.....#.#..#.#......#..#.....##.
.#.#.......#..##........#..##.#
.#.#..#.#...#.......#.#.#..#...
...#......#....#....##.#..#....
......#.......##....##..#.....#
...#.##...##...............#..#
.###....#.#.....##..#.......#.#
#....#..........#...........#.#
...#...............#.#..#....#.
.....#..##..........#..###.....
.....####.....#.#.......#...#..
#.............#...#.......##...
.#....##.......#.#......#.#.##.
.#..#.......#..##...#...#......
#.......#..#..#..#.....#.......
##...#.#.#...........#....#....
.......#..#.#..............#.#.
.....#.......#.......#.#.#.....
....##.##.....#......#.......#.
#...#..#.#....###....##...#.#.#
#..#......#........#.#.#.....#.
###..##..#......#.....#.......#
..##....#.#.#......#..##...#...
.....#..#....#...#.#...#...#...
.....#.#..###.#..#...##......#.
#.#..#....#..#.....#.#...#.#...
.#..#....#.......#..#.......#..
#.........#..#..#.........##..#
..##.##..#..#...##.............
.....###...#..#...##.#..#......
#.##.....##..............#.....
.......#.##.#.##...#.#.......##
...#.#.##...#......#...........
##.#........#.....##.....#.....
.#.....#.............#......#..
....#..##..#..#....#..#.#......
.#.....#....##..##..#...##.....
.##........#.#.#.#..........#.#
...#.#.#..#....#...#..###.##...
.#....#....#.#.#.#....#..#.....
#.#.......#..#..#...........#.#
.....#.....##..#....##.........
....#.##..............#........
.................#....#.......#
...................###...#...#.
...#.#..#..##..##....#.....#...
#...#..........................
.......#..#..#.#..#.....#......
..##.#..#......#...#.##..##..#.
.##.........#.#...........#....
...#...#..##.#......#..#..#....
.....#.#....#...#............#.
.##..#.....##....#...#.........
#......##...#...#............#.
.....#.##...#.#....##..........
.............#.......#.#.......
##....#.#........#....#..##....
....#...##.#....##..#.....#.#..
...##..#....##......#...#......
.####.#..#..#.#...#.#.#....#...
.#........#.##....#.#....#.....
.........#....##..#..#.........
....##...#....##.............#.
....#..##.#....#.#..#...##.....
.....##...#..#....#......#.#...
..........#.......#.##..#.##..#
.......#.........#...#.##......
....##.#.......#...............
....#.......#..##.......##.#.##
#.#..#.#....#.#.........###...#
.#.##.....##..##...........#.#.
...#....##........##...#...#...
.#.##....#.#...#.#..#..#...#...
#....#.##...#.#..#....#.....#..
#..#...#........#...........#..
...........#.......#......#..#.
....##...#......##.....#......#
.#.##.#.#.............#....##..
.#...#...##.#.#........#..##.#.
.#.#........#.#...#..#........#
.###.#.#...#..#..#.#....#..#...
..##..##....#.#............#...
#..........#........#..#.#.#...
.#...#..#..#.#.....#.....#....#
#.....#.#.#.....####.......#...
...#.#........#.#.###...#.....#
.....#.....##....#....#..##...#
..#....###.##.#..#..#....#...#.
.....#.....#...........#.#.###.
.....#......###...#.#...##.....
...........###..#...#....#.#..#
...#..###.....#....#.#...#.....
.......#...#..#..##....#.#.#...
...#..####.###........#.....#..
..#......###..#..#.##..........
....#....##..##..##.......###..
...#.......#..#.#....##........
.#.#.....#.#.#..........#..#..#
.##....##....##...........##.##
........#......#.##....##...#.#
..#.#.....#..#....#..........#.
...........#...............#...
.....####.....#.....###.#..#...
..........####..##.##.#....#...
...#.#.#......#....#..#.#......
.#.#......###.....#....#.......
..#..#..#.......#..#...#.....#.
...#............#......##...###
......#.............#..#..###..
.#.#......#..##.#..#..#.#...#.#
.#.....#.......#..#...........#
..#.###.#..#...#.##..#.##......
....#.#........#..#.#...#.#.##.
.#..##.#..#.#.#...##..#.#......
.......#..#..#..#.....#.#.#..#.
.##.###..##.....#.##..#........
...##..............#.#.##....#.
##....#...#...........#........
..#........#.#.##..#.#...#..#..
.......#.......##.#..#....#.#..
.......#....##..#.#.#..#....#..
..........#....#..#..#....#....
........#.....#.#.....##.......
........##.###.........#.#.#...
###......####...#.#........#...
......#........#......#.....#..
##..#.##..##.###..#........##..
.#..#...#............##.##..#..
...........#..#.#..............
.##.#.#....#...............#..#
.........##.................#..
#............##..##.........##.
##........#.........#..##.#...#
........#.....#..#.........#.##
....#......#.....##.##.........
.#.#.....#.#..#..##....#....#..
.###...#..##....##.....#.#..##.
.#....#.#.......#..#..#...###..
..#.#......#.#..#.....###.....#
#....#..#...#.....#.......#.##.
.#.......##.#.#...#......#.....
###....#.#......#....#.#...##..
...#....####.......##.....#..#.
.#.................#.......##.#
...#.###..........#..##......#.
.....##.#..............##..#...
#.....#..#..........#..#.......
..#...#.#.#.......##.#.....#...
#........#.#........#.#.....#..
#.....#...##....##..##........#
.#.##..#...#....#........#..#..
#..#.....#....#...##......#....
...#...#...#.#.#....##....#.#.#
......#...............#.....#..
.......#.#..#..##.#.....#......
...........##......#...#.......
....##..##.....#.#...#.........
......##..###.......#....#.##..
......#..#.##....#..###..#.....
.....#.........#........##.....
.....####..................#...
.#.#...##................#.....
.#..#...#...#.....#.##..#..#...
.#................#...###....#.
...#....#...........#...#....#.
.......#....##...............#.
.#.#.##..##.......#....#....###
......#.#....#...#..#..........
....#.##.#.#...##.#.#......#...
##....#...##.....#..#.###.#....
.......#......#.........#.#...#
.##.#...........##.........#.#.
##..##.....#...#..#.#...#....#.
#..##......###........#...#....
.....#.#.......#...#..##....##.
.....#.#..#.....#.......#..##..
...#..#..............#.#.......
.#.#...###......###............
.....#.....#...#.###...........
.......#..................#...#
#....#...#...#....#....#.#....#
....#..#............#.#........
#....#..........#.#.#..#..#....
.......#....#......#....#......
.##.#.#...#...#...##...........
.........###.#..#..............
...#........##....#....#....###
....##..#.......#.#...#.#..#.#.
.....##....#..##.........#.....
........##..#........#.........
...........#..#.##..##...#.....
.........#.#..####..#...#.##.##
##..#.#.....##.....#.........#.
..#...#...#....#.#....#.....#.#
.###.#....#.#......#....#......
.##.....#....#.......#.#..#.##.
#..#..##.....#....#...##.....#.
...#.........####.........##..#
..#.....#....###.#.#...#..#....
.........#....#..#.#.........#.
.....###.##..#...#.....#..#..#.
....#......#..#.#...#.....#....
.......#...#..#....#.......#.#.
.#....#............#....####...
#..##..##....#.....#...#.....#.
...#...##...#.#....#...........
.......#####.....#..###.#..#...
.....#.....#.#....#.........#..
.###.#..#...##.##.#.#..#..#....
.#..#.##..#......#..........##.
##....#....#.........###..#....
..#.............#.......#.#....
..#.....#..##...#...###..#.##..
##...##...#.#....#..#..........
...............#.....#.......#.
....#.#......##.#......#...#.#.
.........#.............#.#.....
...#.#.........................
..#..#....##..#...###.##.......
...##.#...##..#.#.##.#...#.##..
.##....#....#.......#.....##..#
.#...............#..#...#......
...##.....##.###....#.....#...#
...#.....#...####....##....#..#
..#.#.###..##.....#........#...
.....##.##..#..#.........##....
........##.....#..........#.##.
..##.#....####..#...........#..
##....#..#..#.#.##.....#...##..
...#...#......#..#.#....#......
##.....##.......##.##....#.....
.........#...##...........#....
.###.#..#....##...#.....#.....#
...#..........#.###..##...#.##.
...#..#....#.#.#.......###.....
....#..#.#.....##...#.#.#.#....
.......##..#...##..##.#....#...
.##..........#.#.#.....#.....#.
#....#......##...#..##.#..#..#.
.#...#.....###..#......#.....#.
.#..#.###.......#.##....###....
#....#....#....#....#..#.##....
..#..#.....#.....#....###.....#
##.###..#...##.......#.#.......
#...##......##....#.#...#....#.
..##.#.#....#...#.....##.......
.#....#..#...#...##..##........
###......#.##....#.#..##.......
...#.....##.#.........#..#.....
.......#.#....#.....##......#..
#..#..............##.#........#
....#.#....#..#.#...##.........
..........#..........#.........
.#.....#.....#.##....#.##..#..#
.......#.......#.#.#.##....#...
..#...........#....#.......##..
..#.#.#.#...##..#.#.#..#...#.#.
..#..#..........#...##....#....
....##.#....#.............#....
.##...##..........#.#..#...#...
#..#..#.##..........##.........
............#.......#..#.....##
....#......#........#..#.##....
#.#......#.#...#.....#.........
..#.....#..#..........#.....#..
.#..#.#.#.##...#..#.#.........#
#...##....#..##..#...#.#.##....
#..##.##.#.##.......#.......#..
#.#.......#........#.##....#.#.
....#..##....##..##......#..##.
#.....#....#.#........####.....
......#...#...###..#...........
.##.#.##...##................##
..##.#.....#.#..#......#.#.....
......#...#........#.....#.##..
#..#.#..#.....#.#..#..##..#.#..
...#.........#.#.#.##...#......
...#..##....#..#.#....#.###.#..
........###................##.#
##...........#......##.##.....#
.#.#.#....#....#....#..........
#.....#........................
....#.....#...#......#.........
....#.#..#..............#......
##.........#..#....#.......#...
.###....#..#.#.####.........#..
..#.#....#.....###..#..........
..........#................#.##"



    String.split(map)
  end

end
