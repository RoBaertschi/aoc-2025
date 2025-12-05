package day5

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part1 :: proc(input: string) -> int {
    input := input
    Range :: struct {
        start, end: int,
    }
    ranges := make([dynamic]Range)
    parsing_ranges := true
    fresh := 0

    for line in strings.split_lines_iterator(&input) {
        if line == strings.trim("", " ") {
            parsing_ranges = false
            continue
        }
        if parsing_ranges {
            n := 0
            minus := strings.index(line, "-")
            start, _ := strconv.parse_int(line[:minus], 10, &n)
            assert(line[n] == '-')
            end, _ := strconv.parse_int(line[n+1:], 10)
            append(&ranges, Range{ start, end })
        } else {
            id, _ := strconv.parse_int(line, 10)
            for range in ranges {
                if range.start <= id && id <= range.end {
                    fresh += 1
                    break
                }
            }
        }
    }

    return fresh
}

part2 :: proc(input: string) -> int {
    input := input
    Range :: struct {
        start, end: int,
    }
    ranges := make([dynamic]Range)

    for line in strings.split_lines_iterator(&input) {
        if line == strings.trim("", " ") {
            break
        }
        n := 0
        minus := strings.index(line, "-")
        start, _ := strconv.parse_int(line[:minus], 10, &n)
        assert(line[n] == '-')
        n2 := 0
        end, _ := strconv.parse_int(line[n+1:], 10, &n2)
        assert(n2 + n + 1 == len(line))

        append(&ranges, Range { start, end })
    }

    slice.sort_by_cmp(ranges[:], proc(r1, r2: Range) -> slice.Ordering {
        if r1.start < r2.start {
            return .Less
        }

        if r2.start < r1.start {
            return .Greater
        }

        if r1.end < r2.end {
            return .Less
        }

        if r2.end < r1.end {
            return .Greater
        }

        return .Equal
    })

    new_ranges := make([dynamic]Range)

    for i := 0; i < len(ranges); i += 1 {
        current_range := ranges[i]

        for i+1 < len(ranges) {
            range := ranges[i+1]
            if current_range.start <= range.start && range.start <= current_range.end {
                current_range.end = max(range.end, current_range.end)
                i += 1
                continue
            }

            if current_range.start <= range.end && range.end <= current_range.end {
                current_range.start = min(range.start, current_range.start)
                i += 1
                continue
            }

            break
        }

        append(&new_ranges, current_range)
    }

    total := 0
    for range in new_ranges {
        total += range.end - range.start + 1
    }
    fmt.println(ranges)
    fmt.println(new_ranges)

    return total
}

main :: proc() {
//     fmt.println(part1(`3-5
// 10-14
// 16-20
// 12-18
//
// 1
// 5
// 8
// 11
// 17
// 32`))

    // fmt.println(part1(#load("input")))

    fmt.println(part2(`3-5
10-14
16-20
12-18

1
5
8
11
17
32`))
    fmt.println(part2(`10-20
15-25
5-15
50-60
50-70
5-30
0-5
30-40
`))

    fmt.println(part2(#load("input")))
}
