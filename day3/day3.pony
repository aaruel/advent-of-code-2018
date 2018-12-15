use "regex"
use "package:../utils/"

class Point
    let x: U32
    let y: U32

    fun string(): String =>
        "(" + x.string() + ", " + y.string() + ")"

    fun add(p2: Point): Point =>
        Point(x + p2.x, y + p2.y)

    new create(x': U32 = 0, y': U32 = 0) =>
        x = x'
        y = y'

class Rect
    let lb: Point
    let wh: Point
    let rt: Point
    let left: U32
    let right: U32
    let top: U32
    let bottom: U32
    
    fun string(): String =>
        "lb: " + lb.string() + " wh: " + wh.string() + " rt: " + rt.string()

    fun area(): U32 =>
        wh.x * wh.y

    new create(xy': Point = Point(), wh': Point = Point()) =>
        lb = xy'
        wh = wh'
        rt = lb + wh
        left = lb.x
        right = rt.x
        top = rt.y
        bottom = lb.y

actor Main
    fun nmax(ns: Array[U32]): U32 =>
        var mx: U32 = 0
        for n in ns.values() do
            mx = if n > mx then n else mx end
        end
        mx
    
    fun nmin(ns: Array[U32]): U32 =>
        var mn: U32 = 99999999
        for n in ns.values() do
            mn = if n < mn then n else mn end
        end
        mn

    fun intersects(a: Rect, b: Rect): Bool =>
        let c1 = a.left < b.right
        let c2 = a.right > b.left
        let c3 = a.top > b.bottom
        let c4 = a.bottom < b.top
        c1 and c2 and c3 and c4

    fun n_inter_area(rects: Array[Rect]): U32 =>
        let la = Array[U32]()
        let ra = Array[U32]()
        let ba = Array[U32]()
        let ta = Array[U32]()
        for rect in rects.values() do
            la.push(rect.left)
            ra.push(rect.right)
            ba.push(rect.bottom)
            ta.push(rect.top)
        end
        let left = nmax(la)
        let right = nmin(ra)
        let bottom = nmax(ba)
        let top = nmin(ta)
        (right - left) * (top - bottom)

    fun part1(env: Env, rects: Array[Rect]): String =>
        while rects.size() > 0 do
            try 
                let rect = rects.delete(0)?
                var i: USize = 0
                let sects = Array[Rect]()
                sects.push(rect)
                while i < rects.size() do
                    if intersects(rect, rects(i)?) then
                        let inter = rects.delete(i)?
                        sects.push(inter)
                    else
                        i = i + 1
                    end
                end
                let ssize = sects.size()
                if ssize > 1 then
                    env.out.print("Num: " + ssize.string())
                    for sect in sects.values() do
                        env.out.print(sect.string())
                    end
                    env.out.print("Area: " + n_inter_area(sects).string())
                    env.out.print("----link----")
                end
            end
        end
        ""

    new create(env: Env) => 
        let squares = Helpers.read_lines[Rect](
            env, 
            "data.txt", 
            {(line: String ref): Rect =>
                var re: Rect = Rect()
                try 
                    let r = Regex("#\\d+ @ (\\d+),(\\d+): (\\d+)x(\\d+)")?
                    let m = r(line.string())?
                    let xy = Point(
                        m(1)?.read_int[U32]()?._1, 
                        m(2)?.read_int[U32]()?._1
                    )
                    let wh = Point(
                        m(3)?.read_int[U32]()?._1, 
                        m(4)?.read_int[U32]()?._1
                    )
                    re = Rect(xy, wh)
                end
                re
            }
        )

        env.out.print(part1(env, squares))
