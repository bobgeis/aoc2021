import lib/[imps]
# https://adventofcode.com/2021/day/3

const
  day = "03"
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

inpath.part1is 3148794
inpath.part2is 2795310
t1path.part1is 198
t1path.part2is 230

# we may need https://nim-lang.org/docs/strutils.html#parseBinInt%2Cstring

proc part0*(path: string): seq[string] =
  path.getLines

proc getdiff(ss:seq[string]): seq[int] =
  result.setLen(ss[0].len)
  for s in ss:
    for i,c in s:
      if c == '1': inc result[i]
      else: dec result[i]

proc part1*(input: seq[string]): int =
  let counts = getdiff(input)
  var
    gamma = ""
    epsilon = ""
  for n in counts:
    if n > 0:
      gamma &= "1"
      epsilon &= "0"
    else:
      gamma &= "0"
      epsilon &= "1"
  result = gamma.parsebinint * epsilon.parsebinint

proc getoxy(ss: seq[string]): int =
  var rem = ss
  for i in 0..rem[0].high:
    if rem.getdiff[i] >= 0:
      rem = rem.filterit(it[i] == '1')
    else:
      rem = rem.filterit(it[i] == '0')
    if rem.len == 1: return rem[0].parsebinint
  0

proc getco2(ss: seq[string]): int =
  var rem = ss
  for i in 0..rem[0].high:
    if rem.getdiff[i] < 0:
      rem = rem.filterit(it[i] == '1')
    else:
      rem = rem.filterit(it[i] == '0')
    if rem.len == 1: return rem[0].parsebinint
  0

proc part2*(input: seq[string]): int =
  result = input.getoxy * input.getco2

makeRunProc(day)
