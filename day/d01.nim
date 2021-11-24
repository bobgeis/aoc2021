import lib/[imps]

const
  day = "01"
  inPath = inputPath(day)
  # t1path = inputPath(day,"t1")

# inpath.part1is 1
# inpath.part2is 2
# t1path.part1is 1
# t1path.part2is 2

proc part0*(path: string): seq[string] =
  path.getLines

proc part1*(input: seq[string]): int =
  result = 0

proc part2*(input: seq[string]): int =
  result = 0

makeRunProc()
when isMainModule: getCliPaths(day).doit(it.run.echoRR)