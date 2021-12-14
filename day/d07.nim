import lib/[imps]
# https://adventofcode.com/2021/day/7

const day = "07"


proc part0*(path: string): seq[int] =
  path.readFile.findAll(re"-?\d+").mapit(it.parseint)

proc part1*(input: seq[int]): int =
  result = 0


proc part2*(input: seq[int]): int =
  result = 0

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")
  o1path = inputPath(day,"o1")

t1path.part1is 37
# inpath.part1is 0
# o1path.part1is 0

# t1path.part2is 0
# inpath.part2is 0
# o1path.part2is 0

makeRunProc(day)
