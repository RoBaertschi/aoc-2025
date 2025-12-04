package day4

import "core:fmt"
import "core:strings"

part1 :: proc(input: string) -> int {
    input := input
    State :: enum{ Empty, Roll }
    grid := make([dynamic][dynamic]State)

    y := 0
    for line in strings.split_lines_iterator(&input) {
        line_states := make([dynamic]State)
        for r, x in line {
            append(&line_states, State.Roll if r == '@' else State.Empty)
        }
        y += 1
        append(&grid, line_states)
    }

    total := 0

    for line, y in grid {
        for cell, x in line {
            if cell == .Roll {
                get_position :: proc(grid: ^[dynamic][dynamic]State, x, y: int) -> State {
                    if y >= len(grid) || y < 0 {
                        return .Empty
                    }

                    line := grid[y]
                    if x >= len(line) || x < 0 {
                        return .Empty
                    }

                    return line[x]
                }

                increase_count :: proc(grid: ^[dynamic][dynamic]State, x, y: int, count: ^int) {
                    if get_position(grid, x, y) == .Roll {
                        count^ += 1
                    }
                }

                count := 0
                increase_count(&grid, x-1, y-1, &count)
                increase_count(&grid,   x, y-1, &count)
                increase_count(&grid, x+1, y-1, &count)
                increase_count(&grid, x-1,   y, &count)
                increase_count(&grid, x-1, y+1, &count)
                increase_count(&grid,   x, y+1, &count)
                increase_count(&grid, x+1, y+1, &count)
                increase_count(&grid, x+1,   y, &count)

                if count < 4 {
                    total += 1
                }
            }
        }
    }

    return total
}

part2 :: proc(input: string) -> int {
    input := input
    State :: enum{ Empty, Roll }
    grid := make([dynamic][dynamic]State)

    y := 0
    for line in strings.split_lines_iterator(&input) {
        line_states := make([dynamic]State)
        for r, x in line {
            append(&line_states, State.Roll if r == '@' else State.Empty)
        }
        y += 1
        append(&grid, line_states)
    }

    total := 0

    for {
        removed_count := 0

        for &line, y in grid {
            for &cell, x in line {
                if cell == .Roll {
                    get_position :: proc(grid: ^[dynamic][dynamic]State, x, y: int) -> State {
                        if y >= len(grid) || y < 0 {
                            return .Empty
                        }

                        line := grid[y]
                        if x >= len(line) || x < 0 {
                            return .Empty
                        }

                        return line[x]
                    }

                    increase_count :: proc(grid: ^[dynamic][dynamic]State, x, y: int, count: ^int) {
                        if get_position(grid, x, y) == .Roll {
                            count^ += 1
                        }
                    }

                    count := 0
                    increase_count(&grid, x-1, y-1, &count)
                    increase_count(&grid,   x, y-1, &count)
                    increase_count(&grid, x+1, y-1, &count)
                    increase_count(&grid, x-1,   y, &count)
                    increase_count(&grid, x-1, y+1, &count)
                    increase_count(&grid,   x, y+1, &count)
                    increase_count(&grid, x+1, y+1, &count)
                    increase_count(&grid, x+1,   y, &count)

                    if count < 4 {
                        total += 1
                        removed_count += 1
                        cell = .Empty
                    }
                }
            }
        }

        if removed_count == 0 {
            break
        }
    }

    return total
}


main :: proc() {
//     fmt.println("part1:", part1(`..@@.@@@@.
// @@@.@.@.@@
// @@@@@.@.@@
// @.@@@@..@.
// @@.@@@@.@@
// .@@@@@@@.@
// .@.@.@.@@@
// @.@@@.@@@@
// .@@@@@@@@.
// @.@.@@@.@.`))
    fmt.println("part1:", part1(#load("input")))

//     fmt.println("part2:", part2(`..@@.@@@@.
// @@@.@.@.@@
// @@@@@.@.@@
// @.@@@@..@.
// @@.@@@@.@@
// .@@@@@@@.@
// .@.@.@.@@@
// @.@@@.@@@@
// .@@@@@@@@.
// @.@.@@@.@.`))
    fmt.println("part2:", part2(#load("input")))
}
