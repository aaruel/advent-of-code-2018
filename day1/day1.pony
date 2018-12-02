use "package:../utils/"
use "files"
use "collections"

actor Main
    fun part1(nums: Array[I32]): String =>
        var acc: I32 = 0
        for num in nums.values() do
            acc = acc + num
        end
        acc.string()

    fun part2(nums: Array[I32]): String =>
        var acc: I32 = 0
        let m = Map[I32, I32]()
        while true do
            for num in nums.values() do
                acc = acc + num
                if m.contains(acc) then
                    return acc.string()
                else
                    try m.insert(acc, 1)? end
                end
            end
        end
        ""

    new create(env: Env) =>
        let nums = Helpers.read_lines[I32](env, "data.txt", {(line: String ref): I32 => 
            line.replace("+", "")
            var num: I32 = 0
            try (num, let _) = line.read_int[I32]()? end
            num
        })

        env.out.print("Part 1: " + part1(nums))
        env.out.print("Part 2: " + part2(nums))
        
        

        