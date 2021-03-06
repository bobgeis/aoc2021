import lib/[imps]
# https://adventofcode.com/2021/day/2

const
  day = "02"
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

inpath.part1is 2019945
inpath.part2is 1599311480
t1path.part1is 150
t1path.part2is 900

type Move = tuple
  dir: Vec2i
  amt: int

proc parseLine(s:string):Vec2i =
  ## one line looks like: "up 5"
  ## directions are: forward, up, down
  let (_,dir,amt) = s.scanTuple("$w $i")
  result = case dir:
    of "up": [0,-1]
    of "forward": [1,0]
    of "down": [0,1]
    else: err &"Unknown direction: {dir}"; [0,0]
  result *= amt

proc part0*(path: string): seq[Vec2i] =
  path.withLines: result.add line.parseLine

proc part1*(input: seq[Vec2i]): int =
  let dest = input.foldl(a + b)
  result = dest[0] * dest[1]

proc part2*(input: seq[Vec2i]): int =
  var pos = [0,0,0]
  for move in input: pos += [move[0], pos[2] * move[0], move[1]]
  result = pos[0] * pos[1]

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
