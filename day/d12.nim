import lib/[imps]
# https://adventofcode.com/2021/day/12

const day = "12"

type
  Graph = Table[string,seq[string]]

proc part0*(path: string): Graph =
  result = initTable[string,seq[string]]()
  path.withLines:
    let (_, lhs, rhs) = line.scantuple("$w-$w")
    result.mgetorput(lhs,@[]).add rhs
    result.mgetorput(rhs,@[]).add lhs

proc countPaths(graph:Graph, start, stop: string, revisit=false):int =
  var count = 0
  proc walk(path: seq[string],revisit:bool) =
    if path[^1] == stop: inc count
    else:
      for edge in graph[path[^1]]:
        if edge[0].isUpperAscii or edge notin path:
          walk(path & edge, revisit)
        elif revisit and edge != "start":
          walk(path & edge, false)
  walk(@[start],revisit)
  count

proc part1*(input: Graph): int =
  input.countPaths("start","end")

proc part2*(input: Graph): int =
  input.countPaths("start","end",true)

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")
  t2path = inputPath(day,"t2")
  t3path = inputPath(day,"t3")

t1path.part1is 10
t2path.part1is 19
t3path.part1is 226
inpath.part1is 4241

t1path.part2is 36
t2path.part2is 103
t3path.part2is 3509
inpath.part2is 122134

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
