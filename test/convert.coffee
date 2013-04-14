
convert = require("../lib/").boots

convert.watch
  from: "test"
  to: "test"
  filter: "coffee"
  extname: "js"
  transform: (string) -> string + " converted"