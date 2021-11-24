## This contains procs and templates useful for this advent of code repo.
import std/[monotimes, os, sequtils, strformat, strutils, tables, times]
import lib/[bedrock, timetemple]
# import lib/[bedrock]

const
  inputDir* = "in"
  githash* = staticexec "git rev-parse --short HEAD"

proc inputPath*(day: string,suffix:string=""): string = &"{inputDir}/i{day}{suffix}.txt"

proc getCliPaths*(day: string): seq[string] =
  var args = commandLineParams()
  if args.len == 0: args.add day
  for arg in args:
    if arg.fileExists:
      result.add arg
    elif arg.inputPath.fileExists:
      result.add arg.inputPath
    elif day.inputPath(arg).fileExists:
      result.add day.inputPath(arg)
    else:
      echo &"Could not find file {arg} or {arg.inputPath} or {day.inputpath(arg)}"

proc readIntLines*(path: string): seq[int] = path.getlines.map(parseInt)

var answers: array[1..2, Table[string, int]] = [
  initTable[string, int](),
  initTable[string, int](),
  ]

proc part1is*(s: string, i: int) = answers[1][s] = i
proc part2is*(s: string, i: int) = answers[2][s] = i
proc checkpart*(part, i: int, path: string) =
  if path in answers[part]:
    let j = answers[part][path]
    if i != j:
      echo &"FAIL: {path} part {part} got {i} but expected {j}"

type
  RunResult* = tuple
    day: string
    path: string
    res: array[2, int]
    dur: array[4, Duration]

template makeRunProc*(): untyped =
  proc run*(path: string = inPath): RunResult =
    timevar durall:
      timevar dur0:
        let input = part0(path)
      var res1: int
      timevar dur1:
        when not defined(skipPart1):
          res1 = part1(input)
      var res2: int
      timevar dur2:
        when not defined(skipPart2):
          res2 = part2(input)
    when not defined(skipPart1):
      checkpart(1, res1, path)
    when not defined(skipPart2):
      checkpart(2, res2, path)
    return (day: day, path: path, res: [res1, res2], dur: [dur0, dur1, dur2, durAll])

proc pretty*(d: Duration): string =
  let parts = d.toParts
  const units = ["ns", "us", "ms", "s", "m"]
  for i in Nanoseconds..Seconds:
    result = &"{parts[i]:>3}{units[i.ord]} {result}"
  if parts[Minutes] > 0:
    result = &"{parts[Minutes]:>3}{units[Minutes.ord]} {result}"

proc echoRR*(rr: RunResult) =
  echo &"Day {rr.day} at #{githash} for {rr.path}"
  echo &"Part1: {rr.res[0]}"
  echo &"Part2: {rr.res[1]}"
  when defined(release):
    echo "Times:"
    echo &"Part0: {rr.dur[0].pretty}"
    when not defined(skipPart1):
      echo &"Part1: {rr.dur[1].pretty}"
    when not defined(skipPart2):
      echo &"Part2: {rr.dur[2].pretty}"
    echo &"Total: {rr.dur[3].pretty}"




