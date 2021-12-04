import lib/[imps]
# https://adventofcode.com/2021/day/3

const
  day = "03"
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

inpath.part1is 3148794
# inpath.part2is 2
t1path.part1is 198
# t1path.part2is 230

# we may need https://nim-lang.org/docs/strutils.html#parseBinInt%2Cstring

proc part0*(path: string): seq[string] =
  path.getLines

proc part1*(input: seq[string]): int =
  var
    counts: seq[int]
    gamma = ""
    epsilon = ""
  counts.setLen(input[0].len)
  for s in input:
    for i,c in s:
      if c == '1':
        inc counts[i]
      else:
        dec counts[i]
  for n in counts:
    if n > 0:
      gamma &= "1"
      epsilon &= "0"
    else:
      gamma &= "0"
      epsilon &= "1"
  result = gamma.parsebinint * epsilon.parsebinint

proc part2*(input: seq[string]): int =
  result = 2

makeRunProc(day)
