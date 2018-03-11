let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  (s)

open Core
open Core_bench.Std

module Yj = struct
  open Yojson

  let read contents = Basic.from_string contents

  let benchit contents =
    let json = read contents in
    (fun () -> Basic.to_string json)

  let dumpit contents = read contents |> Basic.to_string |> Printf.printf "%s\n"
end

let testbuf buf = 
  let rec loop n =
    if n <= 0 then ()
    else begin Buffer.add_string buf "xxxxxxxxxxxxxxxx"; loop (n - 1) end
  in
    loop 100000;
    Buffer.reset buf

let benchbuf bsize =
  let buf = Buffer.create bsize in
  (fun () -> testbuf buf)

let benchit contents =
  let json = Jsonxt.Extended.of_string contents in
  (fun () -> Writer.to_string json)

let bench_fp_to_str () =
  for i = 1 to 1000 do
    ignore (string_of_float 11111111111.1)
  done

let bench_fp_to_str_fast () =
  for i = 1 to 1000 do
    ignore (Jsonxt.Floats.string_of_float_fast_int 11111111111.1)
  done

let bench_fp_to_str_int () =
  for i = 1 to 1000 do
    ignore (string_of_float 11.)
  done

let bench_fp_to_str_fast_int () =
  for i = 1 to 1000 do
    ignore (Jsonxt.Floats.string_of_float_fast_int 11.)
  done

let contents = load_file "test.json.10000"
let test = benchbuf 100
let testxt = benchit contents
(*
let ctrl_lots = Bytes.make 100000 '\x1d'
let testxt_esc () = Writer.to_string (`String ctrl_lots)
; Bench.Test.create ~name:"escape" testxt_esc
*)
let testyj = Yj.benchit contents

let () =
  Printf.printf "%s\n" (Jsonxt.Floats.string_of_float_fast_int 11.)
(*
*)

let () = Command.run (Bench.make_command [
    Bench.Test.create ~name:"FP to string" bench_fp_to_str
  ; Bench.Test.create ~name:"FP to string fast int" bench_fp_to_str_fast
  ; Bench.Test.create ~name:"FP to string/w int" bench_fp_to_str_int
  ; Bench.Test.create ~name:"FP to string fast int/w int" bench_fp_to_str_fast_int
(*
    Bench.Test.create ~name:"buffer" test
  ; Bench.Test.create ~name:"jsonxt" testxt
  ; Bench.Test.create ~name:"yjson" testyj
*)
  ])
