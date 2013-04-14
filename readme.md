
Convert-boots, common logic for source-to-source compile plugins
------

This plugin is based on Rain-boots, read more about it [here][rain-boots]

[rain-boots]: https://github.com/jiyinyiyong/rain-boots

### Usage

Convert-boots provides some APIs for converting. First, import it:

```
{rain, boots} = require "convert-boots"
```

The mehods you may call:  

* `boots.convert`: convert code from one path to another.

Parameter: required, an object like:

```
object =
  from: "origin"
  to: "destination"
  transform: (code) -> compile_method code
  filter: "coffee"
  extname: "js"
```

* `boots.watch_convert`: watch file and call `convert` on save event

Parameter is the same as `boots.convert`.

When Convert-boots is called, it reads file or children from `object.from`,  
filter extensions of children with `object.filter` if neccessary,  
convert with `object.transform`,
then write to directory `object.to` with `object.extname`.  