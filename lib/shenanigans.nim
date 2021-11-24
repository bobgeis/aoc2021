


import std/[macros, monotimes, strformat, tables, times, unittest]

import lib/[bedrock]



proc binBy*[T, U](ts: openArray[T], fn: proc (x: T): U {.closure.}): TableRef[U, seq[T]] =
  ## Given a sequence `ts`, and a proc `fn` that will turn the items of `ts` into something hashable, create a table that bins each of the items into subsequences using the value of returned from `fn`.
  ## Inspired by partition from https://github.com/jabbalaci/nimpykot/blob/master/src/pykot/functional.nim
  runnableExamples:
    import sugar, tables
    let # example 1
      digits = @[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      mod3 = digits.binBy(d => d mod 3)
    assert @[2, 5, 8] == mod3[2]
    let # example 2
      pairs = @[@[1, 2], @[3, 1], @[5, 6], @[9, 5]]
      mins = pairs.binBy(p => p.min)
    assert @[@[5, 6], @[9, 5]] == mins[5]
    let # example 3
      words = @["sam", "so", "am", "alpine"]
      charTable = words.binBy(s => s[0])
    assert @["am", "alpine"] == charTable['a']
  result = newTable[U, seq[T]]()
  for t in ts:
    let s = fn(t)
    var v: seq[T] = result.getOrDefault(s, @[])
    v.add t
    result[s] = v




proc recursiveReplace(body, placeholder, target: NimNode): NimNode =
  ## This is a helper function for DistributeSymbol and DistributeSymbols
  ## Adapted from: https://github.com/Kaynato/AdventOfCode/blob/9223e1b5c8675b1b6664d41b9dc984759c0aba17/graphlib/copymacro.nim
  if body.kind == nnkIdent and body.strVal == placeholder.strVal:
    return target
  else:
    result = copyNimNode(body)
    for n in body:
      result.add(recursiveReplace(n, placeholder, target))

macro DistributeSymbol*(standIn, targetList, body: untyped): untyped =
  ## For every item in `targetList` it will call body with `standIn` replaced with the item.  This can be used to quickly eliminate large amounts of boilerplate.  Many potential uses of this can be served by templates, but it's fun to play with macros.  TODO: better error handling.
  ## Adapted from: https://github.com/Kaynato/AdventOfCode/blob/9223e1b5c8675b1b6664d41b9dc984759c0aba17/graphlib/copymacro.nim
  runnableExamples:
    DistributeSymbol(Op, [`+`, `-`, `*`]):
      proc Op*(a, b: (int, int)): (int, int) =
        (Op(a[0], b[0]), Op(a[1], b[1]))

    let
      a = (2, 3)
      b = a * (2, -1)

    assert a + b == (x: 6, y: 0)
    assert a - b == (x: -2, y: 6)
    assert a * b == (x: 8, y: -9)
  ##
  result = newNimNode(nnkStmtList)
  for target in targetList:
    result.add(body.recursiveReplace(standIn, target))
  result.add()
  # echo treeRepr result

macro DistributeSymbols*(standIns, targetLists, body: untyped): untyped =
  ## Similar to DistributeSymbol, except the standIns and targetLists are both lists themselves.  Every list in targetLists, a new instance of the body will be made with every symbol in standIns replaced by the symbol in the target list with the same offset.  This can be used to quickly eliminate large amounts of boilerplate.  Many potential uses of this can be served by templates, but it's fun to play with macros.  TODO: better error handling.
  ## Adapted from: https://github.com/Kaynato/AdventOfCode/blob/9223e1b5c8675b1b6664d41b9dc984759c0aba17/graphlib/copymacro.nim
  runnableExamples:
    import std/tables
    DistributeSymbols([Name, Num], [[Tab2i, 2], [Tab3i, 3]]):
      type Name[T] = Table[array[Num, int], T]
    var tab3i: Tab3i[char] = initTable[array[3, int], char]()
  ##
  result = newNimNode(nnkStmtList)
  for targetList in targetLists:
    # echo targetList.repr
    var statement = body
    for i in 0..<targetList.len:
      statement = statement.recursiveReplace(standIns[i], targetList[i])
    result.add statement
    continue
  result.add()
  # echo treeRepr result
  # echo result.repr



macro `..=`*(lhs: untyped, rhs: typed): auto =
  ## Unpacking macro: Use this to assign multiple variables from a data structure.  If the data structure uses numerical indexes, then you can use notation like: `[x,y,_,w] ..= someSeq`.  Note that _s are skipped.  If the data structure is an object or named tuple, then you can use notation like: `{x,y,z:zCoord,w} ..= someTuple`.  Note that :s are used to rename variables, otherwise the name of the variable will be the name of the field.  There are three flavors of this macro: `..=` defines lets, `..=^` defines vars, and `..=!` assigns to existing vars.
  ## Adapted from https://github.com/Kaynato/AdventOfCode/blob/master/unpack.nim and https://github.com/technicallyagd/unpack
  runnableExamples:
    type Foo = object
      x, y, z: int
    let foo = Foo(x: 3, y: 5, z: 8)
    {x, y, z: zCoord} ..= foo
    assert [x, y, zCoord] == [3, 5, 8]
    [a, b, _, _, e] ..= @[5, 6, 7, 8, 9, 10, 11, 12, 13]
    assert [a, b, e] == [5, 6, 9]
  let t = genSym()
  result = newStmtList(quote do:
    let `t` = `rhs`)
  if lhs.kind == nnkBracket or lhs.kind == nnkPar:
    for i in 0..<lhs.len:
      let v = lhs[i]
      if $v.toStrLit != "_":
        result.add(quote do:
          let `v` = `t`[`i`])
  elif lhs.kind == nnkCurly or lhs.kind == nnkTableConstr:
    for i in 0..<lhs.len:
      if lhs[i].kind == nnkExprColonExpr:
        let
          v0 = lhs[i][0]
          v1 = lhs[i][1]
        result.add(quote do:
          let `v1` = `t`.`v0`)
      else:
        let v = lhs[i]
        result.add(quote do:
          let `v` = `t`.`v`)
  # echo treeRepr result
  # echo result.repr

macro `..=^`*(lhs: untyped, rhs: typed): auto =
  ## Unpacking macro: Use this to assign multiple variables from a data structure.  If the data structure uses numerical indexes, then you can use notation like: `[x,y,_,w] ..= someSeq`.  Note that _s are skipped.  If the data structure is an object or named tuple, then you can use notation like: `{x,y,z:zCoord,w} ..= someTuple`.  Note that :s are used to rename variables, otherwise the name of the variable will be the name of the field.  There are three flavors of this macro: `..=` defines lets, `..=^` defines vars, and `..=!` assigns to existing vars.
  ## Adapted from https://github.com/Kaynato/AdventOfCode/blob/master/unpack.nim and https://github.com/technicallyagd/unpack
  runnableExamples:
    let s = @[1, 2, 3, 4]
    [a, b, _, c] ..=^ s
    a += c
    assert a == 5
  let t = genSym()
  result = newStmtList(quote do:
    let `t` = `rhs`)
  if lhs.kind == nnkBracket or lhs.kind == nnkPar:
    for i in 0..<lhs.len:
      let v = lhs[i]
      if $v.toStrLit != "_":
        result.add(quote do:
          var `v` = `t`[`i`])
  elif lhs.kind == nnkCurly or lhs.kind == nnkTableConstr:
    for i in 0..<lhs.len:
      if lhs[i].kind == nnkExprColonExpr:
        let
          v0 = lhs[i][0]
          v1 = lhs[i][1]
        result.add(quote do:
          var `v1` = `t`.`v0`)
      else:
        let v = lhs[i]
        result.add(quote do:
          var `v` = `t`.`v`)

macro `..=!`*(lhs: untyped, rhs: typed): auto =
  ## Unpacking macro: Use this to assign multiple variables from a data structure.  If the data structure uses numerical indexes, then you can use notation like: `[x,y,_,w] ..= someSeq`.  Note that _s are skipped.  If the data structure is an object or named tuple, then you can use notation like: `{x,y,z:zCoord,w} ..= someTuple`.  Note that :s are used to rename variables, otherwise the name of the variable will be the name of the field.  There are three flavors of this macro: `..=` defines lets, `..=^` defines vars, and `..=!` assigns to existing vars.
  ## Adapted from https://github.com/Kaynato/AdventOfCode/blob/master/unpack.nim and https://github.com/technicallyagd/unpack
  runnableExamples:
    var x, y, z: int = 0
    let coords = [5, 7, 12]
    [x, y, z] ..=! coords
    assert x + y == z
  let t = genSym()
  result = newStmtList(quote do:
    let `t` = `rhs`)
  if lhs.kind == nnkBracket or lhs.kind == nnkPar:
    for i in 0..<lhs.len:
      let v = lhs[i]
      if $v.toStrLit != "_":
        result.add(quote do:
          `v` = `t`[`i`])
  elif lhs.kind == nnkCurly or lhs.kind == nnkTableConstr:
    for i in 0..<lhs.len:
      if lhs[i].kind == nnkExprColonExpr:
        let
          v0 = lhs[i][0]
          v1 = lhs[i][1]
        result.add(quote do:
          `v1` = `t`.`v0`)
      else:
        let v = lhs[i]
        result.add(quote do:
          `v` = `t`.`v`)

###

when isMainModule:
  import math, strutils
  import bedrock

  # this needs to be at the top level or trying to export will fail
  # abs.liftToMap(absMap, X = true)
  # `+`.liftToMap2(plusMap2, X = true)
  # block:
  #   absMap.liftToMap(absMapMap)
  #   assert @[1, -2, 3].absMap == @[1, 2, 3]
  #   assert @[@[1, -2, 3], @[-3, -4]].absMapMap == @[@[1, 2, 3], @[3, 4]]

  # block:
  #   `+`.liftToMap2(plusMap2)
  #   `+`.liftToMap2padded(plusMap2p)
  #   assert @[-1, -2, 3].plusMap2(@[4, 6, 2]) == @[3, 4, 5]
  #   assert @[-1, -2, 3].plusMap2p(@[4, 6, 2, 2, 3, 4, 5], pad = 1) == @[3, 4, 5,
  #       3, 4, 5, 6]

  # block:
  #   between[int].liftToMap3(btMap)
  #   assert @[1, 2, 3].btMap(@[4, 6, 2], @[-3, 1, 1]) == @[true, true, false]
  #   proc foo(x: string, y: int, z: float): int64 = (x.parseInt + y +
  #       z.floor.int).int64
  #   assert foo("3", 2, 3.0) == 8'i64
  #   foo.liftToMap3(fooMap)
  #   assert fooMap(@["3", "5"], @[2, 3], @[2.0, 10.0]) == @[7'i64, 18]

  block:
    type
      Foo = object
        x, y, z: int
    let foo = Foo(x: 3, y: 5, z: 8)
    {x, y, z: zCoord} ..= foo
    assert [x, y, zCoord] == [3, 5, 8]
    [a, b, _, _, e] ..= @[5, 6, 7, 8, 9, 10, 11, 12, 13]
    assert [a, b, e] == [5, 6, 9]

  block:
    let s = @[1, 2, 3, 4]
    [a, b, _, c] ..=^ s
    a += b + c
    assert a == 7

  block:
    var x, y, z: int = 0
    let coords = [5, 7, 12]
    [x, y, z] ..=! coords
    assert x + y == z

  echo "shenanigans asserts passed"