import lib/[imps]
# https://adventofcode.com/2021/day/8

const day = "08"


proc part0*(path: string): seq[string] =
  path.getLines

proc part1*(input: seq[string]): int =
  result = 0


proc part2*(input: seq[string]): int =
  result = 0

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")
  t2path = inputPath(day,"t2")

# t1path.part1is 0
# t2path.part1is 0
# inpath.part1is 0

# t1path.part2is 0
# t2path.part2is 0
# inpath.part2is 0

makeRunProc(day)
