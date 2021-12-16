import lib/[imps]
# https://adventofcode.com/2021/day/7

const day = "07"


proc part0*(path: string): seq[int] =
  path.readFile.findAll(re"-?\d+").mapit(it.parseint)

proc part1*(input: seq[int]): int =
  var totals:seq[int] = @[]
  for i in input.min..input.max:
    var total = 0
    for j in input:
      total += abs(j-i)
    totals.add total
  totals.min

proc part2*(input: seq[int]): int =
  ## triangular numbers https://en.wikipedia.org/wiki/Triangular_number
  var totals:seq[int] = @[]
  for i in input.min..input.max:
    var total = 0
    for j in input:
      let n = abs(j-i)
      total += (n * (n + 1)) div 2
    totals.add total
  totals.min

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 37
inpath.part1is 356992

t1path.part2is 168
inpath.part2is 101268110

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
