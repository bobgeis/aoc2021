## run all the days in sequence
import std/[macros]
import lib/[imps]

const githash = staticexec "git rev-parse --short HEAD"

const days = [
  "d01",
  "d02",
]

importModules(days,"day/")

# StmtList
#   ProcDef
#     Ident "runAll"
#     Empty
#     Empty
#     FormalParams
#       Empty
#     Empty
#     Empty
#     StmtList
#       LetSection
#         IdentDefs
#           Ident "rrs"
#           Empty
#           Bracket
#             Call
#               DotExpr
#                 Ident "d01"
#                 Ident "run"
#       ForStmt
#         Ident "rr"
#         Ident "rrs"
#         StmtList
#           DotExpr
#             Ident "day"
#             Ident "echoRR"
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
        rr.echoRR)
  # echo result.treeRepr
  # echo result.repr

macro createTimedRunAll():untyped =
  ## create timedRunAll procs
  var
    runexpr = newNimNode(nnkBracket)
  for day in days:
    let dayident = ident(day)
    runexpr.add(newNimNode(nnkCall).add(
      newNimNode(nnkDotExpr).add(
        ident(day),
        ident("timedrun")
    )))
  result = newStmtList(quote do:
    proc timedRunAll() =
      echo &"Advent of Code 2021. All days at #{githash}"
      let trrs = `runexpr`
      for trr in trrs:
        trr.echoTRRshort)
  # echo result.treeRepr
  # echo result.repr

createRunAll
createTimedRunAll

when isMainModule:
  if "time" in commandLineParams():
    timedRunAll()
  else:
    runAll()
