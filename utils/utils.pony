use "files"

primitive Helpers
    fun open_file(env: Env, filename: String): (File | None) =>
        try
            let path = FilePath(env.root as AmbientAuth, filename)?
            match OpenFile(path)
            | let file: File => file
            else
                env.err.print("File Error")
            end
        end
    
    fun read_lines[A = String](
        env: Env, 
        filename: String, 
        f: {(String ref): A}
    ): Array[A!] =>
        match Helpers.open_file(env, filename)
        | let file: File =>
            let lines = FileLines(file)
            try
                let nums = Array[A!]()
                while lines.has_next() do
                    let num: A! = f(lines.next()?)
                    nums.push(num)
                end
                return nums
            end
        end
        Array[A!]()

