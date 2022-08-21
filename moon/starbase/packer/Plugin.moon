class Plugin
  new: (nvim, name) =>
    @nvim = nvim
    @name = name
    @opts = {}
    @dependencies = {}

  require: (name) =>
    dep = Plugin @nvim, name
    table.insert @dependencies, dep
    dep
  
  post_hook: (fn) =>
    @posthook = fn
    @

  tag: (tag) =>
    @opts['tag'] = tag

  run: (run) =>
    @opts['run'] = run
  
  run: (cmd) =>
    @opts['run'] = cmd

  statement: =>
    stmt = {@name}
    if @opts then stmt = @nvim.tbl_extend('force', stmt, @opts)
    requires = {}
    totaldeps = 0
    for k in pairs @dependencies
      totaldeps += 1
      table.insert requires, @dependencies[k]\statement!

    if totaldeps > 0 then stmt['requires'] = requires
    stmt

  call_posthook: =>
    if @posthook then @posthook!
    for _, dep in pairs @dependencies
      dep\call_posthook!

Plugin