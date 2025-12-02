package day2

import "core:strconv"
import "core:fmt"
import "core:strings"

find_invalid_ids :: proc(start, end: int) -> (nums: [dynamic]int) {
    nums = make([dynamic]int)
    
    for i in start..=end {
	digit_count := 0
	value := i

	for value > 0 {
	    value /= 10
	    digit_count += 1
	}

	next_multiplier: for j in 1..<digit_count {
	    (digit_count % j == 0) or_continue
	    items := digit_count / j

	    multiplier := 1
	    for j in 0..<j {
		multiplier *= 10
	    }

	    current_value := i
	    previous_value := current_value % multiplier

	    for k in 1..<items {
		current_test_value := current_value / multiplier
		if previous_value == current_test_value % multiplier {
		    current_value = current_test_value
		    continue
		}
		continue next_multiplier
	    }

	    append(&nums, i)
	    break
	}
    }

    return nums
}

parse_input :: proc(input: string) -> int {
    input_copy := input
    value := 0
    for range in strings.split_iterator(&input_copy, ",") {
	n := 0
	start, _ := strconv.parse_int(range, 10, &n)
	assert(range[n] == '-')
	end, _ := strconv.parse_int(range[n+1:], 10)

	ids := find_invalid_ids(start, end)
	defer delete(ids)
	for id in ids {
	    value += id
	}
    }
    return value
}

input := #load("input", string)


main :: proc() {
    fmt.println(parse_input(input))
    // fmt.println(parse_input("1110-1112"))
    // fmt.println(parse_input("11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"))
    // fmt.println(parse_input("95-115"))
}
