import lib/[imps]
# https://adventofcode.com/2021/day/6

const day = "06"

proc tick(ints: var seq[int]) =
  var toadd = 0
  for idx,i in ints:
    if i == 0:
      ints[idx] = 6
      inc toadd
    else:
      dec ints[idx]
  for a in 1..toadd:
    ints.add 8

proc part0*(path: string): seq[int] =
  path.readFile.findAll(re"-?\d+").mapit(it.parseint)

proc part1*(input: sink seq[int]): int =
  for i in 1..80:
    input.tick
  result = input.len


proc sumfish(tab: CountTable[int]):int = tab.values.toseq.sum

proc part2*(input: seq[int]): int =
  ## The part 1 method is way too slow here!
  var tab = input.toCountTable
  for i in 1..256:
    let toadd = tab[0]
    for j in 0..7:
      tab[j] = tab[j+1]
    tab.inc(6, toadd)
    tab[8] = toadd
  result = tab.sumfish

# paths and solution checking
const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 5934
inpath.part1is 385391

t1path.part2is 26984457539
inpath.part2is 1728611055389

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
