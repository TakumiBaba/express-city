fs = require 'fs'
path = require 'path'
util = require 'util'

exports.logger = (options = {}) ->
  options.format or= 'YY.MM.DD HH:mm:ss'
  options.route or= null
  options.static or= yes
  return (req, res, next) ->
    exists = fs.existsSync path.resolve "public/#{req.url}"
    return next() if !options.static and exists
    route = if exists then 'Static' else no
    ini = Date.now()
    end = res.end
    res.end = ->
      res.end = end
      res.emit 'end'
      res.end.apply @, arguments
    res.on 'end', ->
      util.print "\x1b[90m[#{_.date().format(options.format)}] "
      util.print "\x1b[35m#{req.method.toUpperCase()} "
      util.print "\x1b[37m#{decodeURI req.url} "
      if 500 <= @statusCode
        util.print "\x1b[31m#{@statusCode}\x1b[0m "
      else if 400 <= @statusCode
        util.print "\x1b[33m#{@statusCode}\x1b[0m "
      else if 300 <= @statusCode
        util.print "\x1b[36m#{@statusCode}\x1b[0m "
      else if 200 <= @statusCode
        util.print "\x1b[32m#{@statusCode}\x1b[0m "
      util.print '\x1b[90m('
      if req.route
        util.print "#{req.route.path}"
      else if route
        util.print "#{route}"
      else if options.route
        util.print "#{options.route}"
      else
        util.print if 400 <= @statusCode then "\x1b[31mUnknown" else "Unknown"
      util.print "\x1b[90m - #{Date.now() - ini}ms)\x1b[0m\n"
    next()
