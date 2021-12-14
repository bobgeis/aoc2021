## run all the days in sequence
import std/[macros]
import lib/[imps]

const githash = staticexec "git rev-parse --short HEAD"

const days = [
  "d01",
  "d02",
  "d03",
  "d04",
  "d05",
  "d06",
  "d07",
  "d08",
]

importModules(days,"day/")

macro createRunAll():untyped =
  ## create runAll proc
  var
    runexpr = newNimNode(nnkBracket)
  for day in days:
    let dayident = ident(day)
    runexpr.add(newNimNode(nnkCall).add(
      newNimNode(nnkDotExpr).add(
        ident(day),
        ident("run")
    )))
  result = newStmtList(quote do:
    proc runAll() =
      echo &"Advent of Code 2021. All days at #{githash}"
      let rrs = `runexpr`
      for rr in rrs:
        rr.echoRRshort)
  # echo result.treeRepr
  # echo result.repr

createRunAll

when isMainModule:
  runAll()
