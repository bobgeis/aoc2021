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

proc getcounts(ss:seq[string]): seq[int] =
  result.setLen(ss[0].len)
  for s in ss:
    for i,c in s:
      if c == '1': inc result[i]
      else: dec result[i]

proc getcounts(ss:seq[string], i:int): int =
  ## In part 2 we only need the count at one index at a time
  result = 0
  for s in ss:
    if s[i] == '1': inc result
    else: dec result

proc part1*(input: seq[string]): int =
  let counts = getcounts(input)
  var gamma, epsilon = ""
  for n in counts:
    if n > 0:
      gamma &= "1"
      epsilon &= "0"
    else:
      gamma &= "0"
      epsilon &= "1"
  result = gamma.parsebinint * epsilon.parsebinint

proc getcmp(ss: sink seq[string], p: proc(a,b:int):bool): int =
  for i in 0..ss[0].high:
    if ss.getcounts(i).p(0):
      ss = ss.filterit(it[i] == '1')
    else:
      ss = ss.filterit(it[i] == '0')
    if ss.len == 1: return ss[0].parsebinint

proc part2*(input: seq[string]): int =
  result = input.getcmp(lt) * input.getcmp(ge)

makeRunProc(day)
