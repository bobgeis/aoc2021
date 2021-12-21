import lib/[imps]
# https://adventofcode.com/2021/day/11

const day = "11"


proc part0*(path: string): Seq2i[int] =
  path.withLines:
    result.add line.toSeqChar.mapit(it.parseint)

proc echoBoard(ss: Seq2i[int]) =
  for row in ss:
    echo row.join

proc tick(ss:var Seq2i[int]): int =
  let bounds = [ss[0].high, ss.high]
  var
    blinks: seq[Vec2i] = @[]
    blinked = initHashSet[Vec2i]()
  for x in 0..bounds.x:
    for y in 0..bounds.y:
      inc ss[x,y]
      if ss[x,y] == 10:
        blinks.add [x,y]
  while blinks.len > 0:
    let v = blinks.pop
    for dir in dirs2d8:
      let dv = dir + v
      if not dv.aabb(ori2i,bounds): continue
      if dv in blinked: continue
      inc ss[dv]
      if ss[dv] == 10:
        blinks.add dv
    blinked.incl v
    inc result
  for v in blinked:
    ss[ v.x, v.y ] = 0

proc part1*(input: sink Seq2i[int]): int =
  for i in 1..100:
    result += input.tick

proc synced(ss: Seq2i[int]):bool =
  for row in ss:
    if row.anyit(it > 0): return false
  true

proc part2*(input: sink Seq2i[int]): int =
  while not input.synced:
    discard input.tick
    inc result

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 1656
inpath.part1is 1585

t1path.part2is 195
inpath.part2is 382

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
