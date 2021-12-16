import lib/[imps]
import std/[re]
# https://adventofcode.com/2021/day/04

const
  day = "04"
  inPath = inputPath(day)
  t1path = inputPath(day,"t1")

inpath.part1is 63552
inpath.part2is 9020
t1path.part1is 4512
t1path.part2is 1924

type
  Board = object
    board: Table[int,Vec2i]
    unmarked: HashSet[int]
    xs,ys: Vec5i
    done:bool

proc initBoard(ints: seq[int]): Board =
  var
    board = initTable[int,Vec2i]()
    unmarked = initHashSet[int]()
  for idx,i in ints:
    unmarked.incl i
    board[i] = [idx mod 5, idx div 5]
  return Board(board:board, unmarked:unmarked, xs:[0,0,0,0,0], ys:[0,0,0,0,0],done:false)

proc part0*(path: string): (seq[int],seq[Board]) =
  let ints = path.readFile.split("\n\n").mapit(it.findAll(re"-?\d+").mapit(it.parseint))
  var boards: seq[Board] = @[]
  for idx in 1..ints.high:
    boards.add initBoard(ints[idx])
  (ints[0],boards)

proc score(board:Board,num:int):int =
  var sum = board.unmarked.toSeq.sum
  sum * num

proc update(board:var Board,num:int):int =
  if num notin board.unmarked: return 0
  if board.done: return 0
  board.unmarked.excl num
  let v = board.board[num]
  inc board.xs[v.x]
  inc board.ys[v.y]
  if board.xs.anyit(it == 5) or board.ys.anyit(it == 5):
    board.done = true
    return num * board.unmarked.toSeq.sum
  return 0

proc propagate(ints:seq[int],boards: sink seq[Board]): (int,int) =
  var
    numleft = boards.len
    first,last:int
  for num in ints:
    for board in boards.mitems:
      let i = board.update(num)
      if i > 0:
        if numleft == boards.len:
          first = i
        elif numleft == 1:
          last = i
          return (first,last)
        dec numleft
  (0,0)

proc part1*(input: (seq[int],seq[Board])): int =
  return propagate(input[0],input[1])[0]

proc part2*(input: (seq[int],seq[Board])): int =
  return propagate(input[0],input[1])[1]

makeRunProc(day)

when isMainModule:
  getCliPaths(day).doit(it.run.echoRR)
