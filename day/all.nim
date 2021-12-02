## run all the days in sequence
import std/[macros, os, strformat]
import lib/[aocutils]

const githash = staticexec "git rev-parse --short HEAD"

const days = [
  "d01",
  "d02",
]

# now some silly macros to import and build procs based on the contents of the `days` array

macro makeImports(): untyped =
  ## create an import statement for every day in the `days` array
  ## For whatever reason, imports declared from macros CANNOT be relative!
  # dumpTree:
  #   import d01
  #   import day/d01
  # StmtList
  #   ImportStmt
  #     Ident "d01"
  # let
  #   d1 = "d01"
  #   tmp = &"import day/[{d1}]"
  # result = parseStmt(tmp)
  var impNode = newNimNode(nnkImportStmt)
  for day in days:
    impNode.add(ident(&"day/{day}"))
  result = newStmtList()
  result.add(impNode)
  # echo result.treeRepr
  # echo result.repr

makeImports

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
