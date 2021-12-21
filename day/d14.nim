import lib/[imps]
# https://adventofcode.com/2021/day/14

const day = "14"


proc part0*(path: string): (string,Table[string,string]) =
  let
    parts = path.readfile.split("\n\n")
    templ = parts[0]
  var pairs = inittable[string,string]()
  for line in parts[1].splitlines:
    let (_, base, insert) = line.scantuple("$w -> $w")
    pairs[base] = insert
  (templ,pairs)

proc part1*(input: (string,Table[string,string])): int =
  let pairs = input[1]
  var
    prev = input[0]
    next = ""
  for i in 1..10:
    next = ""
    for idx in 0..prev.high-1:
      next.add prev[idx]
      next.add pairs[prev[idx..idx+1]]
    next.add prev[^1].toString
    prev = next
  var ctab = initCountTable[char]()
  for c in next: ctab.inc(c)
  let counts = ctab.values.toseq.sorted
  result = counts[^1] - counts[0]


proc part2*(input: (string,Table[string,string])): int =
  result = 0

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 1588
inpath.part1is 2170

# t1path.part2is 2188189693529
# inpath.part2is 0

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
