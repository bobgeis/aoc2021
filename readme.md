
# Advent of Code 2021

[This repo](https://github.com/bobgeis/aoc2021) contains soluations for [Advent of Code 2021](https://adventofcode.com/2021) written in [nim](https://nim-lang.org/).

## Links

- [Awesome Advent of Code](https://github.com/Bogdanp/awesome-advent-of-code#nim)
- [aoc subreddit](https://old.reddit.com/r/adventofcode/)
- [nim aoc 2021 thread]()

## Nim References

- [nim compiler](https://nim-lang.org/docs/nimc.html)
- [nim manual](https://nim-lang.org/docs/manual.html)
- [nim std lib](https://nim-lang.org/docs/lib.html)
- [nimscript](https://nim-lang.org/docs/nimscript.html)
- [nimble](https://nimble.directory/)
- [itertools](https://github.com/narimiran/itertools)
- [memo](https://github.com/andreaferretti/memo)
- [stint](https://github.com/status-im/nim-stint)
- [stew](https://github.com/status-im/nim-stew)

## repo

Generic setup. Using vscode with [nim](https://marketplace.visualstudio.com/items?itemName=kosz78.nim) and [indent-rainbow](https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow) extensions. Plus other not nim-specific ones.

For nimble packages, the `stint` package is vital for dealing with very large ints. `memo` and `itertools` are sometimes very helpful and convenient.

I have a large 'lib' of helper code from previous years that I may re-use this year. `aocutils` is for working in the repo (eg finding data files for each day). `bedrock` has misc utilities that don't import anything else from the repo; it's the 'bottom'. `vecna` has a bunch of convenience utilities for working with coordinates (x,y,etc), which happens a lot in aoc. `graphwalk` is an implementation of bfs and Dijkstra's algorithm, because they come up a lot. `shenanigans` is for experimentation and causing trouble.

There are a number of scripts in `config.nims`. `nim dr 01` will compile and run day 1 with the default input. `nim dt 01` will compile and run with performance optimizations. Specific input files can be passed like `nim dr 01 i t1`, where `i` represents the default input, `t1` represents the first test input, etc.

___
___
___

## SPOILERS BELOW

___
___
___

## all

The day/all.nim program exists to sequentially run all the days on their default input and check that the answers are still correct. The timing below is not a scientific benchmark, but should give on a ballpark on which days are slow/fast.

```
$ nim dt all
nim c  -d:fast day/all.nim
Advent of Code 2021. All days at #94f4af0
Day 01:     0.208 ms
Day 02:     0.156 ms
Day 03:     0.264 ms
Day 04:     3.902 ms
Day 05:    75.790 ms
Day 06:     4.367 ms
Day 07:     3.913 ms
Day 08:     2.251 ms

real    0m0.099s
user    0m0.065s
```

___

# d00

day 0 is a template for each day. It has stubs for part0 (work common to part 1 and part 2) and part1 and part 2. It also has calls to `part1is` and `part2is` for test and input paths, which are used to verify that refactoring doesn't break something we know works.

___

## d01
[Link](https://adventofcode.com/2021/day/1)

The first task is pretty straightfoward arithmetic. It's mostly a chance for people to make sure their setup is working.

There's a little bit of a trick to part 2: it says to compare the sums, but you can skip the sums and just compare input values 3 offsets apart.

___

## d02
[Link](https://adventofcode.com/2021/day/2)

This is another pretty straightforward task, but requires some string parsing. I used [scanf](https://nim-lang.org/docs/strscans.html). I expect lots of solutions will use regex or peg though.

I had forgotten that scanTuple was introduced in nim 1.6, and have switched to use that (it just makes things more concise).

There is also a clever `include` trick used by [pietroppeter](https://pietroppeter.github.io/adventofnim/2021/day02.html) that embeds the input in the compiled program. This is pretty neat, and allows us to treat the input itself as code. (Note: I'm not going to do use this here because I'm considering the run time performance, but the not compile time. If you use the input at compile time, you could make the run time arbitrarily short.)

___

## d03
[Link](https://adventofcode.com/2021/day/3)

Part 2 was a bit confusing at first. Tidying up, and seeing what some other people had done, I saw something useful: if you are making a var copy of an immutable arg, you can just declare that arg as `sink`. This will use the arg "as is" if it's the last use, or make a full copy if not, potentially saving you from having to copy.

___

## d04
[Link](https://adventofcode.com/2021/day/4)

Bingo! I found it convenient to define a type for this one.

___

## d05
[Link](https://adventofcode.com/2021/day/5)

My implementation of day 5 is _very_ slow compared to the other days so far. I should come back to this with a mind to improve it.

___

## d06
[Link](https://adventofcode.com/2021/day/6)

Part 2 of day 6 was the first time so far where the naive brute force approach was too slow. Thinking for a bit, one notices that the order of the fix in the list is not actually important, and just keeping count of the number of fish at each number is sufficient. This makes things much faster.

___

## d07
[Link](https://adventofcode.com/2021/day/7)

Naive brute force approach worked: loop from the leftmost crab to the rightmost one, finding the cost at each position, then take the minimum cost.

___

## d08
[Link](https://adventofcode.com/2021/day/8)

If you treat the encoded numbers as sets of characters, you can pretty quickly decode everything by doing set differences and comparing set sizes. There's probably a better way than what I did, but it worked well enough.

<!-- ___ -->

<!-- ## d09 -->
<!-- [Link](https://adventofcode.com/2021/day/9) -->

<!-- ___ -->

<!-- ## d10 -->
<!-- [Link](https://adventofcode.com/2021/day/10) -->

<!-- ___ -->

<!-- ## d11 -->
<!-- [Link](https://adventofcode.com/2021/day/11) -->

<!-- ___ -->

<!-- ## d12 -->
<!-- [Link](https://adventofcode.com/2021/day/12) -->

<!-- ___ -->

<!-- ## d13 -->
<!-- [Link](https://adventofcode.com/2021/day/13) -->

<!-- ___ -->

<!-- ## d14 -->
<!-- [Link](https://adventofcode.com/2021/day/14) -->

<!-- ___ -->

<!-- ## d15 -->
<!-- [Link](https://adventofcode.com/2021/day/15) -->

<!-- ___ -->

<!-- ## d16 -->
<!-- [Link](https://adventofcode.com/2021/day/16) -->

<!-- ___ -->

<!-- ## d17 -->
<!-- [Link](https://adventofcode.com/2021/day/17) -->

<!-- ___ -->

<!-- ## d18 -->
<!-- [Link](https://adventofcode.com/2021/day/18) -->

<!-- ___ -->

<!-- ## d19 -->
<!-- [Link](https://adventofcode.com/2021/day/19) -->

<!-- ___ -->

<!-- ## d20 -->
<!-- [Link](https://adventofcode.com/2021/day/20) -->

<!-- ___ -->

<!-- ## d21 -->
<!-- [Link](https://adventofcode.com/2021/day/21) -->

<!-- ___ -->

<!-- ## d22 -->
<!-- [Link](https://adventofcode.com/2021/day/22) -->

<!-- ___ -->

<!-- ## d23 -->
<!-- [Link](https://adventofcode.com/2021/day/23) -->

<!-- ___ -->

<!-- ## d24 -->
<!-- [Link](https://adventofcode.com/2021/day/24) -->

<!-- ___ -->

<!-- ## d25 -->
<!-- [Link](https://adventofcode.com/2021/day/25) -->

<!-- ___ -->

<!-- ## Afterword -->

___

