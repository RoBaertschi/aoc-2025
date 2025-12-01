package day1

import "core:fmt"
import "core:strconv"
import "core:strings"

import os "core:os/os2"

input := #load("input", string)

main :: proc() {
    value := 50
    zeros := 0
    exact_zeros := 0

    lines := strings.split(input, "\n", context.temp_allocator)

    for line, i in lines {
        (line != "") or_continue

        if len(line) < 2 {
            fmt.eprintfln("Incorrect line length for line %q at %d", line, i)
            os.exit(1)
        }

        direction: enum { L, R }

        switch line[0] {
        case 'L': direction = .L
        case 'R': direction = .R
        case:
            fmt.eprintfln("Incorrect direction specifier %c", line[0])
            os.exit(1)
        }

        move :: proc(value: ^int, num: int, zeros: ^int) {
            for i in 0..<abs(num) {
                if num > 0 {
                    value^ += 1
                } else {
                    value^ -= 1
                }

                if value^ > 99 {
                    value^ = 0
                }
                if value^ < 0 {
                    value^ = 99
                }

                if value^ == 0 {
                    zeros^ += 1
                }
            }
        }

        num, _ := strconv.parse_int(line[1:])
        wrapped := false
        switch direction {
        case .L:
            move(&value, -num, &zeros)
        case .R:
            move(&value, num, &zeros)
        }

        if value == 0 {
            exact_zeros += 1
        }
    }

    fmt.println("Zeros:", zeros, "Exact Zeros (for problem 1):", exact_zeros, " Value:", value)
}
