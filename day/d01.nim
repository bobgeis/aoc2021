import lib/[imps]
# https://adventofcode.com/2021/day/1

const
  day = "01"
  inPath* = inputPath(day)
  t1path = inputPath(day,"t1")

inpath.part1is 1184
inpath.part2is 1158
t1path.part1is 7
t1path.part2is 5

proc part0*(path: string): seq[int] =
  path.readIntLines

proc part1*(input: seq[int]): int =
  result = 0
  for i in 1..input.high:
    if input[i] > input[i-1]: inc result

proc part2*(input: seq[int]): int =
  result = 0
  when defined(d01oldmethod):
    # the old method actually adds them up, run with:
    # nim dr -d:d01oldmethod d01
    var
      curr = input[0] + input[1] + input[2]
      last = curr
    for i in 3..input.high:
      last = curr
      curr = input[i] + input[i-1] + input[i-2]
      if curr > last: inc result
  else:
    # the old method actually compared the sums
    # but this is unnecessary
    # because the sums being compared are adjacent
    # so they share some numbers which can be subtracted out
    # leaving just the first number of the old sum
    # and the last number of the new sum
    for i in 3..input.high:
      if input[i] > input[i-3]: inc result

makeRunProc(day)
