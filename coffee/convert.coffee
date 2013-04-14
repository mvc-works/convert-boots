
{rain, boots} = require "rain-boots"
show = console.log

fs = require "fs"
path = require "path"

exports.boots = {}

format = (options) ->
  options = options or {}
  options.from ?= "./"
  options.to ?= "./"
  options.interval ?= 600
  options.transform ?= (string) -> string
  options

replace = (file_name, options) ->
  dirname = path.dirname file_name
  child_name = path.basename(file_name)
    .replace ".#{options.filter}", ".#{options.extname}"
  path.join dirname, child_name

convert_file = (options) ->
  show "convert_file", options
  boots.throttle options.interval, ->
    show "core function", options.from
    content = fs.readFileSync options.from, "utf8"
    content = options.transform content
    if options.to.match(/\S+\.\w+$/)?
      to_file = replace options.to, options
    else
      child_name = options.from.match(/[^\\]+$/)[0]
      child_name = replace child_name, options
      to_file = path.join options.to, child_name
    fs.writeFileSync to_file, content
    show "converted", to_file

watch_convert_file = (options) ->
  show "watch_convert_file", options
  fs.watchFile options.from, interval: 200, ->
    convert_file options

watch_directory = (options) ->
  show "watch_directory", options
  children = fs.readdirSync options.from
  show children
  children.forEach (child) ->
    if (path.extname child)[1..] is options.filter
      clone_options =
        __proto__: options
        from:  path.join options.from, child
        to: path.join options.to, child
      watch_convert_file clone_options

convert = (options) ->
  show "the convert function", options
  status = fs.statSync options.from
  if status.isDirectory()
    show "isDirectory"
    children = fs.readdirSync options.from
    children.forEach (child) ->
      clone_options =
        __proto__: options
        from: path.join options.from, child
        to: path.join options.to, child
      convert_file clone_options
  else
    convert_file options

watch_convert = (options) ->
  show "watch_convert start"
  status = fs.statSync options.from
  if status.isDirectory()
    watch_directory options
  else
    watch_convert_file options

exports.boots.convert = (options) ->
  show "convert function start"
  convert (format options)

exports.boots.watch = (options) ->
  show "watch function start"
  options = format options
  watch_convert options