import lib/[imps]
# https://adventofcode.com/2021/day/8

const day = "08"


proc part0*(path: string): seq[seq[seq[string]]] =
  path.withlines:
    result.add(line.split('|').mapit(it.split(' ')))

proc part1*(input: seq[seq[seq[string]]]): int =
  var tab = initCountTable[int]()
  for line in input:
    for answer in line[1]:
      inc tab, answer.len
  # 1 = 2 segments
  # 4 = 4 segments
  # 7 = 3 segments
  # 8 = 7 segments
  result = tab[2] + tab[4] + tab[3] + tab[7]

proc tocset*(s:string):set[char] =
  ## turn a string into a set of char
  for c in s: result.incl c

proc makemap(codewords:seq[string]): Table[set[char],char] =
  result = initTable[set[char],char]()
  var code = initTable[int,seq[set[char]]]()
  for word in codewords:
    code.mgetorput(word.len,@[]).add word.tocset
  let
    one = code[2][0]
    seven = code[3][0]
    four = code[4][0]
    eight = code[7][0]
  var
    zero,two,three,five,six,nine: set[char]
  result[one] = '1'
  result[seven] = '7'
  result[four] = '4'
  result[eight] = '8'
  for lensix in code[6]:
    if (lensix - four).len == 2:
      nine = lensix
      result[lensix] = '9'
    elif (lensix - one).len == 4:
      zero = lensix
      result[lensix] = '0'
    else:
      six = lensix
      result[lensix] = '6'
  for lenfive in code[5]:
    if (lenfive - one).len == 3:
      three = lenfive
      result[lenfive] = '3'
    elif (lenfive - four).len == 2:
      five = lenfive
      result[lenfive] = '5'
    else:
      two = lenfive
      result[lenfive] = '2'

proc readmap(map: Table[set[char],char],digits:seq[string]): int =
  var num = ""
  for digit in digits:
    if digit.len == 0: continue
    num.add map[digit.tocset]
  return num.parseint

proc part2*(input: seq[seq[seq[string]]]): int =
  result = 0
  for line in input:
    let map = makemap(line[0])
    result += readmap(map,line[1])

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 26
inpath.part1is 352

t1path.part2is 61229
inpath.part2is 936117

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
