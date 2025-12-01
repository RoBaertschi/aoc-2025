package day1

import "core:fmt"
import "core:mem"
import "core:time"
import "core:strconv"
import "core:strings"

import os "core:os/os2"

// input := #load("input", string)
// TEST_INPUT_EXPECTED_ZEROS :: 6684
// TEST_INPUT_EXPECTED_LAST_VALUE :: 70

// input := "R1000"
// TEST_INPUT_EXPECTED_ZEROS :: 10
// TEST_INPUT_EXPECTED_LAST_VALUE :: 50

input := "L150"
TEST_INPUT_EXPECTED_ZEROS :: 2
TEST_INPUT_EXPECTED_LAST_VALUE :: 0

// input := `L68
// L30
// R48
// L5
// R60
// L55
// L1
// L99
// R14
// L82
// `
// TEST_INPUT_EXPECTED_ZEROS :: 6
// TEST_INPUT_EXPECTED_LAST_VALUE :: 32

solution1 :: proc(input: string) -> (int, int, int) {
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

    return zeros, exact_zeros, value
}

solution2 :: proc(input: string) -> (int, int) {
    value := 50
    zeros := 0


    // NOTE: No utf8 handling needed
    for i := 0; i < len(input); i += 1 {

        direction: enum { L, R } = input[i] == 'L' ? .L : .R
        i += 1

        n: int
        num, _ := strconv.parse_int(input[i:], 10, &n)
        i += n

        switch direction {
        case .L:
            value -= num
            switch {
            case value > 0:
            case value == 0:
                zeros += 1
            case value < 0:
                hundreds := abs(value) / 100

                if value + num != 0 {
                    zeros += 1
                }

                value += hundreds * 100
                zeros += hundreds

                if value < 0 {
                    value += 100
                }
            }

        case .R:
            value += num
            switch {
            case value > 99:
                hundreds := value / 100
                value -= hundreds * 100
                zeros += hundreds
            }
        }
    }

    return zeros, value
}

solution3 :: proc(input: string) -> (int, int) {
    value := 50
    zeros := 0


    // NOTE: No utf8 handling needed
    for i := 0; i < len(input); i += 1 {

        direction: enum { L, R } = input[i] == 'L' ? .L : .R
        i += 1

        n: int
        num, _ := strconv.parse_int(input[i:], 10, &n)
        i += n

        switch direction {
        case .L:
            value -= num
            switch {
            case value > 0:
            case value == 0:
                zeros += 1
            case value < 0:
                hundreds := abs(value) / 100
                rest := abs(value) % 100
                if rest > 0 && value + num != 0 {
                    zeros += 1
                }

                value = 100 - rest

                zeros += hundreds
            }

        case .R:
            value += num
            switch {
            case value > 99:
                hundreds := value / 100
                value -= hundreds * 100
                zeros += hundreds
            }
        }
    }

    return zeros, value
}

benchmark :: proc(name: string, solution: #type proc(input: string) -> (int, int), input: string, expected_zeros, expected_last_value: int) {
    diff: time.Duration

    // warmup
    for i in 0..<5 {
        _, _ = solution(input)
    }

    zeros, last_value: int
    {
        time.SCOPED_TICK_DURATION(&diff)
        zeros, last_value = solution(input)
    }
    free_all(context.temp_allocator)
    fail := false
    if zeros != expected_zeros {
        fmt.eprintfln("%v failed: expected_zeros(%v) != %v", name, expected_zeros, zeros)
        fail = true
    }
    if last_value != expected_last_value {
        fmt.eprintfln("%v failed: expected_last_value(%v) != %v", name, expected_last_value, last_value)
        fail = true
    }
    if fail do return
    duration := diff

    times_per_second     := f64(time.Second) / f64(diff)
    megabytes_per_second := f64(len(input)) / f64(1024 * 1024) * times_per_second
    fmt.printfln("%v took %v, %v times per second, %v megabytes per second", name, duration, times_per_second, megabytes_per_second)
}

main :: proc() {
    benchmark("solution1", proc(input: string) -> (int, int) {
        zeros, _, value := solution1(input)
        return zeros, value
    }, input, TEST_INPUT_EXPECTED_ZEROS, TEST_INPUT_EXPECTED_LAST_VALUE)
    benchmark("solution2", solution2, input, TEST_INPUT_EXPECTED_ZEROS, TEST_INPUT_EXPECTED_LAST_VALUE)
    benchmark("solution3", solution3, input, TEST_INPUT_EXPECTED_ZEROS, TEST_INPUT_EXPECTED_LAST_VALUE)
}
