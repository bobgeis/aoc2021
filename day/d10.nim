import lib/[imps]
# https://adventofcode.com/2021/day/10

const day = "10"

const scoretab = {
    ')' : 3,
    ']' : 57,
    '}' : 1197,
    '>' : 25137,
  }.toTable()

proc part0*(path: string): seq[string] =
  path.getLines

proc part1*(input: seq[string]): int =
  var errs:seq[(char,char,int, int, string)] = @[]
  for line in input:
    var expect: seq[char] = @[]
    for idx,c in line:
      if c == '(': expect.add ')'
      elif c == '<': expect.add '>'
      elif c == '{': expect.add '}'
      elif c == '[': expect.add ']'
      elif c == expect[^1]: discard expect.pop
      else:
        errs.add (expect[^1],c,idx,scoretab[c],line)
        break
  result = errs.reduce((acc:int,e) => acc + e[3],0)


proc part2*(input: seq[string]): int =
  result = 0

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 26397
inpath.part1is 370407

t1path.part2is 288957
# inpath.part2is 0

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
