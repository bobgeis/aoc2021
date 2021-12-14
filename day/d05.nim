import lib/[imps]
# https://adventofcode.com/2021/day/5

const
  day = "05"
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

proc parseline(s:string):(Vec2i,Vec2i) =
  let (_,x1,y1,x2,y2) = s.scanTuple("$i,$i -> $i,$i")
  ([x1,y1],[x2,y2])

proc part0*(path: string): seq[(Vec2i,Vec2i)] =
  path.withLines: result.add line.parseLine

proc part1*(input: seq[(Vec2i,Vec2i)]): int =
  var tab = initCountTable[Vec2i]().Ctab2i
  for vs in input:
    if vs[0].x == vs[1].x or vs[0].y == vs[1].y:
      for x in countbetween(vs[0].x,vs[1].x):
        for y in countbetween(vs[0].y,vs[1].y):
          tab.inc([x,y])
  for n in tab.values:
    if n > 1: inc result

t1path.part1is 5
inpath.part1is 6267

proc part2*(input: seq[(Vec2i,Vec2i)]): int =
  var tab = initCountTable[Vec2i]().Ctab2i
  for vs in input:
    for v in countbetween(vs[0],vs[1]):
      tab.inc(v)
  for n in tab.values:
    if n > 1: inc result

t1path.part2is 12
inpath.part2is 20196

makeRunProc(day)
