module Item = struct
  type t = {
    str : string
  ; cost : float
  } [@@deriving yojson]
end

module Stock = struct
  type t = {
    desc : string
  ; inventory : int
  ; backorder : int option
  ; items : Item.t list
  } [@@deriving yojson]
end

let () =
  let item1 = { Item.str = "Hienz Baked Beans"; cost = 1.37 } in
  let item2 = { Item.str = "Baxtors Baked Beans"; cost = 1.47 } in
  let stock = { Stock.desc = "Beans"; inventory = 2; backorder = Some 3; items = [item1; item2] } in
  let json = Stock.yojson_of_t stock in
  print_endline (Yojson.Safe.to_string json)