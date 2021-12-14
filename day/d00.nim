import lib/[imps]
# https://adventofcode.com/2021/day/0

const
  day = "00"
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")
  o1path = inputPath(day,"o1")


proc part0*(path: string): seq[string] =
  path.getLines

proc part1*(input: seq[string]): int =
  result = 1

# t1path.part1is 1
# inpath.part1is 1
# o1path.part1is 1

proc part2*(input: seq[string]): int =
  result = 2

# t1path.part2is 2
# inpath.part2is 2
# o1path.part2is 2

makeRunProc(day)
