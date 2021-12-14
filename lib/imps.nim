## imps: the little demons on your shoulder telling you to write macros
## This module imports and then exports frequently used modules.
## Note that some modules will still need to be imported explicitly,
## because the module symbol will be needed in scope for disambiguation.

# std lib modules: https://nim-lang.org/docs/lib.html
import std/[algorithm, deques, math, memfiles, options,
  os, parsecsv, parseutils, re, sequtils, sets,
  strformat, strscans, strtabs, strutils, sugar,
  tables, unittest]

# nimble pkgs: https://nimble.directory/
import pkg/[itertools, memo, stint]

# local lib modules: src/lib/
import lib/[aocutils, bedrock, graphwalk, shenanigans, timetemple, vecna]
# import lib/[aocutils, bedrock, graphwalk, shenanigans, vecna]


export algorithm, deques, math, memfiles, options,
  os, parsecsv, parseutils, re, sequtils, sets,
  strformat, strscans, strtabs, strutils, sugar,
  tables, unittest

export itertools, memo, stint

export aocutils, bedrock, graphwalk, shenanigans, timetemple, vecna
# export aocutils, bedrock, graphwalk, shenanigans, vecna
