import lib/[imps]
# https://adventofcode.com/2021/day/14

const day = "14"


proc part0*(path: string): seq[string] =
  path.getLines

proc part1*(input: seq[string]): int =
  result = 0


proc part2*(input: seq[string]): int =
  result = 0

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 1588
# inpath.part1is 0

# t1path.part2is 0
# inpath.part2is 0

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
