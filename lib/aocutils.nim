## This contains procs and templates useful for this advent of code repo.
import std/[monotimes, os, sequtils, strformat, strutils, tables, times]
import pkg/[stint]
import lib/[bedrock, timetemple]

const
  inputDir* = "in"
  githash* = staticexec "git rev-parse --short HEAD"

proc inputPath*(day: string,suffix:string=""): string = &"{inputDir}/i{day}{suffix}.txt"

proc getCliPaths*(day: string): seq[string] =
  ## Tries to find the input files to evaluate.
  ## - nothing or "i" or "day" uses the default path for `day`
  ## - multiple args will be run in sequence
  ## example cli commands:
  ##   nim dr 01 # runs the default input file for day 01
  ##   nim drf 01 i t1 t2 # runs input file and two test files
  var args = commandLineParams()
  for arg in args:
    if arg.fileExists:
      result.add arg
    elif arg.inputPath.fileExists:
      result.add arg.inputPath
    elif day.inputPath(arg).fileExists:
      result.add day.inputPath(arg)
    elif (arg == "i" or arg == "day") and day.inputPath.fileExists:
      result.add day.inputPath
    elif (arg == "time"): continue
    else:
      echo &"Could not find file {arg} or {arg.inputPath} or {day.inputpath(arg)}"
  if result.len == 0:
    result.add day.inputPath

proc readIntLines*(path: string): seq[int] =
  path.withLines:
    result.add(line.parseInt)

# answers are almost always positive integers,
# but they CAN be strings,
# or large integers (stint's Int128 or Int256)
# so let's turn them all into strings for checking purposes
var answers: array[1..2, Table[string, string]] = [
  initTable[string, string](),
  initTable[string, string](),
  ]

proc part1is*[T](s: string, a: T) = answers[1][s] = $a
proc part2is*[T](s: string, a: T) = answers[2][s] = $a

proc checkpart*[T](part: int, path: string, a: T) =
  if path in answers[part]:
    let b = answers[part][path]
    if $a != b:
      echo &"FAIL: {path} part {part} got {$a} but expected {b}"

type
  RunResult* = tuple
    day: string
    path: string
    res: array[2, int]
    dur: array[4, Duration]

proc prettyDur*(d: Duration): string =
  let us = d.inMicroseconds
  when defined(showtimeparts):
    let parts = d.toParts
    const units = ["ns", "us", "ms", "s", "m"]
    for i in Nanoseconds..Seconds:
      result = &"{parts[i]:>3}{units[i.ord]} {result}"
    if parts[Minutes] > 0:
      result = &"{parts[minutes]:>3}{units[Minutes.ord]} {result}"
  else:
    result = &"{us.float64 / 1000.0:>9.3f} ms"

proc echoRR*(rr: RunResult) =
  echo &"Day {rr.day} at #{githash} for {rr.path}"
  echo &"Part1: {rr.res[0]}"
  echo &"Part2: {rr.res[1]}"
  when defined(release):
    echo "Times:"
    echo &"Part0: {rr.dur[0].prettyDur}"
    when not defined(skipPart1):
      echo &"Part1: {rr.dur[1].prettyDur}"
    when not defined(skipPart2):
      echo &"Part2: {rr.dur[2].prettyDur}"
    echo &"Total: {rr.dur[3].prettyDur}"

proc echoRRshort*(rr: RunResult) =
  echo &"Day {rr.day}: {rr.dur[3].prettyDur}"

template makeRunProc*(day:string): untyped =
  ## Generate a run proc and timedrun proc
  ## from the day's part1 and part2 functions,
  ## and if the module is main, then run the proc
  ## and echo the output.

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
      checkpart(1, path, res1)
    when not defined(skipPart2):
      checkpart(2, path, res2)
    return (day: day, path: path, res: [res1, res2], dur: [dur0, dur1, dur2, durAll])

