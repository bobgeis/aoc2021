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

proc pluck*[T](s:set[T]):T =
  for i in s.items: return i

const
  digits = [
    "abcdefg",
    "cf",
    "acdeg",
    "acdfg",
    "bcdf",
    "abdfg",
    "abdefg",
    "acf",
    "abcdefg",
    "abcdfg",
  ]
  disets = digits.mapit(it.tocset)

# { a } = seven - one / 3 - 2
# { b,d } = four - one / 4 - 2
# { g } = three - four - seven

# 0 = 6 segments
# 1 = 2 segments
# 2 = 5 segments
# 3 = 5 segments
# 4 = 4 segments
# 5 = 5 segments
# 6 = 6 segments
# 7 = 3 segments
# 8 = 7 segments
# 9 = 6 segments


proc part2*(input: seq[seq[seq[string]]]): int =
  result = 0
  for line in input:
    var
      code = initTable[int,seq[set[char]]]()
      stod = initTable[set[char],char]()
      num = ""
    for word in line[0]:
      code.mgetorput(word.len,@[]).add word.tocset
    let
      one = code[2][0]
      seven = code[3][0]
      four = code[4][0]
      eight = code[7][0]
    var
      zero,two,three,five,six,nine: set[char]
    stod[one] = '1'
    stod[seven] = '7'
    stod[four] = '4'
    stod[eight] = '8'
    for lensix in code[6]:
      if (lensix - four).len == 2:
        nine = lensix
        stod[lensix] = '9'
      elif (lensix - one).len == 4:
        zero = lensix
        stod[lensix] = '0'
      else:
        six = lensix
        stod[lensix] = '6'
    for lenfive in code[5]:
      if (lenfive - one).len == 3:
        three = lenfive
        stod[lenfive] = '3'
      elif (lenfive - four).len == 2:
        five = lenfive
        stod[lenfive] = '5'
      else:
        two = lenfive
        stod[lenfive] = '2'
    for digit in line[1]:
      if digit.len == 0: continue
      num.add stod[digit.tocset]
    result += num.parseint


const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 26
inpath.part1is 352

t1path.part2is 61229
inpath.part2is 936117

makeRunProc(day)
