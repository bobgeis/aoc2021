import lib/[imps]
# https://adventofcode.com/2021/day/9

const day = "09"


proc part0*(path: string): seq[seq[int]] =
  path.readfile.splitlines.toSeq2iChar.mapit(it.map(parseint))

proc part1*(input: seq[seq[int]]): int =
  for j,row in input:
    for i,cell in row:
      if [i,j].getAdj4.allit(cell < input.getor(it,9)):
        result += cell + 1

proc part2*(input: seq[seq[int]]): int =
  # find low points
  var lps: seq[Vec2i] = @[]
  for j,row in input:
    for i,cell in row:
      if [i,j].getAdj4.allit(cell < input.getor(it,9)):
        lps.add [i,j]
  # flood fill from low points
  var
    basins: seq[int] = @[]
    basin:int
    queue:Deque[Vec2i]
    checked:Set2i
    curr: Vec2i
  for lp in lps:
    basin = 1
    queue = @[lp].toDeque
    checked = @[lp].toSet
    while queue.len > 0:
      curr = queue.popFirst
      for adj in curr.getAdj4:
        if adj notin checked and input.getor(adj,9) < 9:
          inc basin
          checked.incl adj
          queue.addLast adj
    basins.add basin
  basins.sorted(Descending)[0..2].foldl(a*b)

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 15
inpath.part1is 444

t1path.part2is 1134
# inpath.part2is 1168440

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)