open System.IO
open System

let explode (s:string) = [for c in s -> c]

let input = File.ReadAllLines("../day_01.input")

let list = input.[0] |> explode |> List.map(Char.GetNumericValue >> int) 

let (solution, _) = list @ [ list.Head ] |> List.fold (fun (acc, last) x -> if x = last then (acc+x, x) else (acc, x)) (0, 0)

solution |> printfn "The solution to the capture is %i."

list |> List.chunkBySize ((list |> List.length)/2) 
    |> List.rev
    |> List.concat
    |> List.zip(list)
    |> List.fold (fun acc (x, y) -> if x = y then acc+x else acc) 0
    |> printfn "The solution to the new capture is %i."