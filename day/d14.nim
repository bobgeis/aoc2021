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


## Brute force does NOT work for part 2! we need to do something smarter...
## We don't actually care about the order of the char in the string, just how many times each char appears.
## The last time this happened, a CountTable was the way to go.

proc tick(pairs:CountTable[string],maptab:Table[string,string]):CountTable[string] =
  for k,v in pairs:
    result.inc k[0] & maptab[k], v
    result.inc maptab[k] & k[1], v

proc part2*(input: (string,Table[string,string])): int =
  let
    maptab = input[1]
    templ = input[0]
  var ctab = initCountTable[string]()
  for idx in 0..templ.high-1:
    ctab.inc templ[idx..idx+1]
  for i in 1..40:
    ctab = ctab.tick(maptab)
  var score = initCountTable[char]()
  score.inc templ[^1] # count that last char of the template string
  for k,v in ctab:
    score.inc k[0], v
  return score.largest.val - score.smallest.val

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 1588
inpath.part1is 2170

t1path.part2is 2188189693529
inpath.part2is 2422444761283

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
