module HelloWorldApp.Program

open Falco
open Falco.Routing
open Falco.HostBuilder



type Ordspraksitem =
    { ordsprak: string
      beskrivning: Option<string> }

let parseBeskrivning items =
    match items with
    | [|_; besk|] -> Some besk
    | _ -> None

let parse filepath =
    let lines = System.IO.File.ReadLines filepath
    Seq.toList lines
    |> Seq.map (_.Split(";"))
    |> Seq.map (fun items ->
        { ordsprak = items[0]
          beskrivning = parseBeskrivning items })

let ordsprak = parse "ordsprak.txt"
let rnd = System.Random()

[<EntryPoint>]
let main args =
    webHost args { endpoints [ get "/" (Response.ofJson (Seq.randomChoiceWith rnd ordsprak )) ] }
    0
