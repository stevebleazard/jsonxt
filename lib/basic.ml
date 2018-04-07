module Compliance = struct
  type json = Json.Basic.json

  open Tokens

  let lex_number = function
  | INFINITY -> COMPLIANCE_ERROR "inf not supported"
  | NEGINFINITY -> COMPLIANCE_ERROR "-inf not supported"
  | NAN -> COMPLIANCE_ERROR "nan not supported"
  | FLOAT _ as token -> token
  | token -> token

  let lex_integer token = token (* CR sbleazard: fix bounds *)

  let lex_largeint = function
  | LARGEINT s -> FLOAT (float_of_string s)
  | token -> token

  let lex_variant _ = false
  let lex_tuple _ = false

  let number_to_string f =
    match classify_float f with
    | FP_normal | FP_subnormal | FP_zero -> Json_float.string_of_float_fast_int f
    | FP_infinite -> raise (Failure "infinity not supported")
    | FP_nan -> raise (Failure "nan not supported")

  let largeint s = `Float (float_of_string s)
  let integer i = `Int i
  let null = `Null
  let string s = `String s
  let bool b = `Bool b
  let assoc a = `Assoc a
  let list l = `List l
  let tuple l = raise (Failure "tuples not supported in basic mode")
  let variant l = raise (Failure "variants not supported in basic mode")

  let number = function
  | `Float f ->     `Float f
  | `Infinity ->    `Null
  | `Neginfinity -> `Null
  | `Nan ->         `Null

end

module Lexxer = Compliant_lexxer.Make(Compliance)
module Parser = Parser.Make(Compliance)
include Json_string_file.Make (Lexxer) (Parser)
type t = json

include Json_writer_string.Make(Compliance)
include Json_writer_file.Make(Compliance)