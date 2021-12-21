import lib/[imps]
# https://adventofcode.com/2021/day/10

const day = "10"

const
  errscore = {
    ')' : 3,
    ']' : 57,
    '}' : 1197,
    '>' : 25137,
  }.toTable()
  compscore = {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4,
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
        errs.add (expect[^1],c,idx,errscore[c],line)
        break
  result = errs.foldl(a + b[3],0)


proc score(s:seq[char]):int =
  var idx = s.len
  while idx > 0:
    dec idx
    result *= 5
    result += compscore[s[idx]]

proc part2*(input: seq[string]): int =
  var completions: seq[seq[char]] = @[]
  for line in input:
    var
      err = false
      expect: seq[char] = @[]
    for idx,c in line:
      if c == '(': expect.add ')'
      elif c == '<': expect.add '>'
      elif c == '{': expect.add '}'
      elif c == '[': expect.add ']'
      elif c == expect[^1]: discard expect.pop
      else:
        err = true
        break
    if not err:
      completions.add expect
  completions.mapit(it.score).sorted[completions.len div 2]

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 26397
inpath.part1is 370407

t1path.part2is 288957
inpath.part2is 3249889609

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
