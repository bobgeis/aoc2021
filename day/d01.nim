import lib/[imps]

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
  var
    curr = input[0] + input[1] + input[2]
    last = curr
  for i in 3..input.high:
    last = curr
    curr = input[i] + input[i-1] + input[i-2]
    if curr > last: inc result

makeRunProc(day)
