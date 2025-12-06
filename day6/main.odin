package day6

import "core:strconv"
import "core:strings"
import "core:fmt"

part1 :: proc(input: string) -> int {
    input := input
    lines := make([dynamic][]int)
    Op :: enum {
	Add,
	Mul,
    }
    ops := make([dynamic]Op)

    for line in strings.split_lines_iterator(&input) {
	line := line
	skip_whitespace :: proc(line: ^string) -> bool {
	    for len(line^) > 0 && line^[0] == ' ' {
		line^ = line^[1:]
	    }

	    return len(line^) > 0
	}

	skip_whitespace(&line) or_continue
	if line[0] == '*' || line[0] == '+' {
	    for len(line) > 0 {
		skip_whitespace(&line) or_break
		switch line[0] {
		case '+':
		    append(&ops, Op.Add)
		case '*':
		    append(&ops, Op.Mul)
		}
		line = line[1:]
	    }
	    break
	}

	nums := make([dynamic]int)

	for len(line) > 0 {
	    skip_whitespace(&line) or_break
	    n := 0
	    num, _ := strconv.parse_int(line, 10, &n)
	    line = line[n:]
	    append(&nums, num)
	}
	append(&lines, nums[:])
    }

    total := 0
    for i in 0..<len(ops) {
	op := ops[i]


	switch op {
	case .Add:
	    num := 0
	    for j in 0..<len(lines) {
		num += lines[j][i]
	    }
	    total += num
	case .Mul:
	    num := 1
	    for j in 0..<len(lines) {
		num *= lines[j][i]
	    }
	    total += num
	}
    }

    return total
}

part2_attempt2 :: proc(input: string) -> int {
    lines := strings.split_lines(input)
    line_char_len := len(lines[0])

    total := 0
    current_nums := make([dynamic]int)
    for i := line_char_len - 1; i >= 0; i -= 1 {
	line_num := 0
	for line in lines[:len(lines)-1] {
	    ch := line[i]
	    if '0' <= ch && ch <= '9' {
		line_num *= 10
		line_num += int(ch - '0')
	    }
	}
	if line_num == 0 {
	    continue
	}

	append(&current_nums, line_num)

	op := lines[len(lines)-1][i]
	switch op {
	case '+':
	    num := 0
	    for n in current_nums {
		num += n
	    }
	    total += num
	    clear(&current_nums)
	case '*':
	    num := 1
	    for n in current_nums {
		num *= n
	    }
	    total += num
	    clear(&current_nums)
	}
    }
    
    return total
}

// part2 :: proc(input: string) -> int {
//     input := input
//     lines := make([dynamic][]string)
//     Op :: enum {
// 	Add,
// 	Mul,
//     }
//     ops := make([dynamic]Op)
// 
//     for line in strings.split_lines_iterator(&input) {
// 	line := line
// 
// 	// nums := make([dynamic]string)
// 	// for i := 0; i < len(line); i += 1 {
// 	//     start := i
// 	//     for line[i] == ' ' {
// 	// 	i += 1
// 	//     }
// 	//     for '0' <= line[i] && line[i] <= '9' {
// 	// 	i += 1
// 	//     }
// 	//     if line[i] == '*' || line[i] == '+' {
// 	// 	switch line[i] {
// 	// 	case '+':
// 	// 	    append(&ops, Op.Add)
// 	// 	case '*':
// 	// 	    append(&ops, Op.Mul)
// 	// 	}
// 	//     }
// 
// 	//     append(&nums, line[start:i])
// 	// }
// 
// 	
// 	skip_whitespace :: proc(line: ^string) -> bool {
// 	    for len(line^) > 0 && line^[0] == ' ' {
// 		line^ = line^[1:]
// 	    }
// 
// 	    return len(line^) > 0
// 	}
// 
// 	skip_whitespace(&line) or_continue
// 	if line[0] == '*' || line[0] == '+' {
// 	    for len(line) > 0 {
// 		skip_whitespace(&line) or_break
// 		switch line[0] {
// 		case '+':
// 		    append(&ops, Op.Add)
// 		case '*':
// 		    append(&ops, Op.Mul)
// 		}
// 		line = line[1:]
// 	    }
// 	    break
// 	}
// 
// 	nums := make([dynamic]string)
// 
// 	for len(line) > 0 {
// 	    n := 0
// 	    num, _ := strconv.parse_int(line, 10, &n)
// 	    append(&nums, line[:n])
// 	    line = line[n:]
// 	}
// 	append(&lines, nums[:])
//     }
// 
//     total := 0
//     for i in 0..<len(ops) {
// 	op := ops[i]
// 
// 	nums := make([dynamic]int)
// 	for j in 0..<len(lines) {
// 	    append(&nums, lines[j][i])
// 	}
// 
// 	Num :: struct{ num, digit_count: int }
// 	nums_with_digit_count := make([dynamic]Num)
// 	max_num_digits := 0
// 	for i := 0; i < len(nums); i += 1 {
// 	    value := nums[i]
// 	    digit_count := 0
// 	    for value > 0 {
// 		value /= 10
// 		digit_count += 1
// 	    }
// 
// 	    max_num_digits = max(digit_count, max_num_digits)
// 	    append(&nums_with_digit_count, Num { nums[i], digit_count })
// 	}
// 
// 	actual_nums := make([]int, max_num_digits)
// 	for &actual_num, i in actual_nums {
// 	    for &num in nums_with_digit_count {
// 		(num.digit_count >= i+1) or_continue
// 		digit := num.num % 10
// 		num.num /= 10
// 		actual_num *= 10
// 		actual_num += digit
// 	    }
// 	}
// 
// 	switch op {
// 	case .Add:
// 	    num := 0
// 	    for n in actual_nums {
// 		num += n
// 	    }
// 	    total += num
// 	case .Mul:
// 	    num := 1
// 	    for n in actual_nums {
// 		num *= n
// 	    }
// 	    total += num
// 	}
//     }
// 
//     return total
// }


main :: proc() {
    // fmt.println(part1(#load("input")))
//     fmt.println(part1(`123 328  51 64 
//  45 64  387 23 
//   6 98  215 314
// *   +   *   +  `))

//    fmt.println(part2_attempt2(`123 328  51 64 
// 45 64  387 23 
//  6 98  215 314
//*   +   *   +  `))

    fmt.println(part2_attempt2(#load("input")))
}
