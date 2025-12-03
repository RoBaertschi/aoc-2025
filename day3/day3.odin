package day3

import "core:fmt"
import "core:strings"

part1 :: proc(input: string) -> int {
    // biggest := make([dynamic]int)
    total := 0
    input := input
    for line in strings.split_lines_iterator(&input) {
        largest, second_largest := 0, 0
        largest_where := 0
        for r, i in line[:len(line)-1] {
            value := int(r - '0')
            if value > largest {
                largest = value
                largest_where = i
            }
        }

        for r, i in line {
            (i > largest_where) or_continue
            value := int(r - '0')
            if value > second_largest {
                second_largest = value
            }
        }

        // append(&biggest, largest * 10 + second_largest)
        total += largest * 10 + second_largest
    }

    return total
}

part2 :: proc(input: string) -> int {
    // biggest := make([dynamic]int)
    total := 0
    input := input
    for line in strings.split_lines_iterator(&input) {
        value := 0
        start_pos := -1
        for i in 0..<12 {
            largest := 0
            for r, i in line[:len(line)-(11 - i)] {
                (i > start_pos) or_continue
                value := int(r - '0')
                if value > largest {
                    largest = value
                    start_pos = i
                }
            }

            value *= 10
            value += largest
        }

        // append(&biggest, largest * 10 + second_largest)
        total += value
    }

    return total
}

main :: proc() {
//     fmt.println(part1(`987654321111111
// 811111111111119
// 234234234234278
// 818181911112111`))
    // fmt.println(part1(#load("input")))

//     fmt.println(part2(`987654321111111
// 811111111111119
// 234234234234278
// 818181911112111`))
    fmt.println(part2(#load("input")))
}
