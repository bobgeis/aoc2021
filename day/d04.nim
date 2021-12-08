import lib/[imps]
import std/[re]
# https://adventofcode.com/2021/day/04

const
  day = "04"
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

inpath.part1is 63552
# inpath.part2is 2
t1path.part1is 4512
# t1path.part2is 2

type
  Board = object
    board: Table[int,Vec2i]
    unmarked: HashSet[int]
    xs,ys: Vec5i

proc initBoard(ints: seq[int]): Board =
  var
    board = initTable[int,Vec2i]()
    unmarked = initHashSet[int]()
  for idx,i in ints:
    unmarked.incl i
    board[i] = [idx mod 5, idx div 5]
  return Board(board:board, unmarked:unmarked, xs:[0,0,0,0,0], ys:[0,0,0,0,0])

proc part0*(path: string): seq[seq[int]] =
  result = path.readFile.split("\n\n").mapit(it.findAll(re"-?\d+").mapit(it.parseint))

proc score(board:Board,num:int):int =
  var sum = board.unmarked.toSeq.sum
  sum * num

proc update(board:var Board,num:int):int =
  if num notin board.unmarked: return 0
  board.unmarked.excl num
  let v = board.board[num]
  inc board.xs[v.x]
  inc board.ys[v.y]
  if board.xs.anyit(it == 5) or board.ys.anyit(it == 5):
    return num * board.unmarked.toSeq.sum
  return 0

proc part1*(input: seq[seq[int]]): int =
  var boards:seq[Board] = @[]
  for idx in 1..input.high:
    boards.add initBoard(input[idx])
  for num in input[0]:
    for board in boards.mitems:
      let i:int = board.update(num)
      if i > 0: return i
  return 0

proc part2*(input: seq[seq[int]]): int =
  result = 2

makeRunProc(day)
