import lib/[imps]
# https://adventofcode.com/2021/day/8

const day = "08"


proc part0*(path: string): seq[seq[seq[string]]] =
  path.withlines:
    result.add(line.split('|').mapit(it.split(' ')))

proc part1*(input: seq[seq[seq[string]]]): int =
  var tab = initCountTable[int]()
  for line in input:
    for answer in line[1]:
      inc tab, answer.len
  # 1 = 2 segments
  # 4 = 4 segments
  # 7 = 3 segments
  # 8 = 7 segments
  result = tab[2] + tab[4] + tab[3] + tab[7]

proc part2*(input: seq[seq[seq[string]]]): int =
  result = 0

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 26
inpath.part1is 352

t1path.part2is 61229
# inpath.part2is 0

makeRunProc(day)
