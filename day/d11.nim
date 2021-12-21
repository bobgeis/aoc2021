import lib/[imps]
# https://adventofcode.com/2021/day/11

const day = "11"


proc part0*(path: string): Seq2i[char] =
  path.getLines.toseq2ichar

proc part1*(input: sink Seq2i[char]): int =
  result = 0



proc part2*(input: Seq2i[char]): int =
  result = 0

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 1656
# inpath.part1is 0

# t1path.part2is 0
# inpath.part2is 0

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
