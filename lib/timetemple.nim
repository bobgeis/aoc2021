
## This file contains templates and procs used for timing code.
## It was initially inspired by Kaynato's https://github.com/Kaynato/AdventOfCode/blob/master/timeit.nim

import std/[monotimes, times]

template timevar*(dur: untyped, body: untyped): untyped =
  ## A timing template, it takes the name of a var that it will declare as a Duration.
  ## Durations are in std/times
  ## Adapted from Kaynato's https://github.com/Kaynato/AdventOfCode/blob/master/timeit.nim
  var dur: Duration
  let t1 = getMonoTime()
  body
  let t2 = getMonoTime()
  dur = t2 - t1

template timeadd*(dur: var Duration, body: untyped): untyped =
  ## A timing template, it takes the name of a var Duration that it will add to
  ## Durations are in std/times
  ## Adapted from Kaynato's https://github.com/Kaynato/AdventOfCode/blob/master/timeit.nim
  let t1 = getMonoTime()
  body
  let t2 = getMonoTime()
  dur += t2 - t1

