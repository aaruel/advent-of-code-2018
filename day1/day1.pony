use "files"
use "collections"

actor Main
    fun get_file(env: Env, filename: String): (File | None) =>
        try
            let path = FilePath(env.root as AmbientAuth, filename)?
            match OpenFile(path)
            | let file: File => file
            else
                env.err.print("File Error")
            end
        end

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
        match get_file(env, "data.txt")
        | let file: File =>
            let lines = FileLines(file)
            try
                let nums = Array[I32]()
                while lines.has_next() do
                    let line = lines.next()?
                    line.replace("+", "")
                    (let num, let _) = line.read_int[I32]()?
                    nums.push(num)
                end

                // Part 1
                env.out.print("Part 1: " + part1(nums))

                // Part 2
                env.out.print("Part 2: " + part2(nums))
            end
        end

        