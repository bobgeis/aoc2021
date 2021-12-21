import lib/[imps]
# https://adventofcode.com/2021/day/13

const day = "13"


proc part0*(path: string): (Set2i,seq[(string,int)]) =
  let parts = path.readfile.split("\n\n")
  var
    dots = initHashSet[Vec2i]()
    folds: seq[(string,int)] = @[]
  for dot in parts[0].splitLines:
    let (_, x, y) = dot.scantuple("$i,$i")
    dots.incl [x,y]
  for fold in parts[1].splitlines:
    let (_, dir, coord) = fold.scanTuple("fold along $w=$i")
    folds.add (dir,coord)
  (dots,folds)

proc fold(dots:Set2i,f:(string,int)):Set2i =
  let (dir,coord) = f
  result = initHashSet[Vec2i]()
  for v in dots:
    if dir == "x":
      result.incl [if v.x > coord: 2 * coord - v.x else: v.x,v.y]
    else: # dir == "y"
      result.incl [v.x, if v.y > coord: 2 * coord - v.y else: v.y]

proc part1*(input: (Set2i,seq[(string,int)])): int =
  result = input[0].fold(input[1][0]).len

proc part2*(input: (Set2i,seq[(string,int)])): int =
  let dots = input[1].foldl(a.fold(b), input[0])
  echo dots.drawset((v) => (if v in dots: '#' else: '.'))

const
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

t1path.part1is 17
# inpath.part1isnot 863 # get this if you mix up the x and y
inpath.part1is 724

# t1path.part2is 0
# #####
# #...#
# #...#
# #...#
# #####
# inpath.part2is 0
# .##..###....##.###..####.###..#..#.#...
# #..#.#..#....#.#..#.#....#..#.#..#.#...
# #....#..#....#.###..###..#..#.#..#.#...
# #....###.....#.#..#.#....###..#..#.#...
# #..#.#....#..#.#..#.#....#.#..#..#.#...
# .##..#.....##..###..####.#..#..##..####
# CPJBERUL

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
