use "package:../utils/"
use "collections"
use "itertools"

actor Main
    fun part1(ids: Array[String]): String =>
        var two: U32 = 0
        var three: U32 = 0
        for id in ids.values() do
            var is_two: U32 = 0
            var is_three: U32 = 0
            for i in id.values() do
                match id.count(String.from_utf32(i.u32()))
                | 2 => is_two = 1
                | 3 => is_three = 1
                end
            end
            two = two + is_two
            three = three + is_three
        end
        let mult = two * three
        mult.string()

    fun part2(ids: Array[String]): String =>
        var dist: U32 = 0
        var str1 = ""
        var str2 = ""
        for id1 in ids.values() do
            let ssize = id1.size()
            for id2 in ids.values() do
                let comp = Iter[U8](id1.values()).zip[U8](id2.values())
                let hamming = comp.fold[U32](0, {(sum, value) => 
                    if value._1 == value._2 then sum + 1 else sum end
                })
                if (hamming > dist) and (ssize != hamming.usize()) then
                    dist = hamming
                    str1 = id1
                    str2 = id2
                end
            end
        end
        str1 + " " + str2

    new create(env: Env) =>
        let ids = Helpers.read_lines(
            env, 
            "data.txt", 
            {(line: String ref): String => line.string()}
        )

        env.out.print("Part 1: " + part1(ids))
        env.out.print("Part 2: " + part2(ids))

