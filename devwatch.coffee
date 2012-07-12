# compile with `{ echo '#!/usr/bin/env node'; coffee -c -p -b devwatch.coffee ; }`

fs = require("fs")
util = require('util')
path = require('path')
exec = require('child_process').exec

growl = require('growl')

imgbasePath = path.resolve( __dirname + "/imgs/" )
console.log imgbasePath
class DevWatch extends require('events').EventEmitter
	constructor: ->
		return

	watch: ( filter, cmds )=>

		@getFiles filter, ( err, files )=>
			if files.length
				for file, idx in files
					console.log "\nWATCHING file: ", file
					@run( files[ idx ], cmds )
					fs.watchFile file, @_onFileChanged( file, cmds )

			else
				console.error "No matching files found"
			return

		return
	
	_onFileChanged: ( file, cmds )=>
		return ( curr, prev )=>
			if curr.ctime.getTime() > prev.ctime.getTime()
				console.log "\nCHANGE detected", file
				@run( file, cmds )
			return

	run: ( _file, _cmds )=>
		[ cmds, tmplData ] = @_calcCmd( _file, _cmds )
		growl("#{ tmplData.name }.#{tmplData.ext}", { title:'DEVWATCH - RUN', image: imgbasePath + "/terminal_icon_blue.png" })
		for cmd in cmds
			do( cmd )=>
				exec cmd, ( err, stdout, stderr )->
					if stderr.length
						_error = stderr.replace( /\n/, '' )
						console.log "ERROR", _error
						# send a beep
						`
						process.stdout.write( '\7' )
						`
						growl( "#{ tmplData.name }.#{tmplData.ext}\n" + _error, { title:'DEVWATCH - ERROR', image: imgbasePath + "/terminal_icon_red.png"  })
					else if stdout.length
						_info = "info: " + stdout.replace( /\n/, '' ) + "\ncmd: " + cmd
						console.log "DONE", _info
						growl(_info, { title:'DEVWATCH - DONE', image: imgbasePath + "/terminal_icon_green.png"  })
					else
						console.log "DONE", "file: #{ tmplData.name }.#{tmplData.ext}" + "\ncmd: " + cmd
						growl("file: #{ tmplData.name }.#{tmplData.ext}" + "\ncmd: " + cmd, { title:'DEVWATCH - DONE', image: imgbasePath + "/terminal_icon_green.png"  })
					return
				return
		return


	_calcCmd: ( __file, cmds )=>
		tmplData = {}
		
		_idxPath = __file.lastIndexOf( "/" )
		tmplData.path = __file.substr( 0, _idxPath+1 )
		tmplData.file = __file.substr( _idxPath+1 )

		_idxExt = tmplData.file.lastIndexOf( "." )
		tmplData.name = tmplData.file.substr( 0, _idxExt )
		tmplData.ext = tmplData.file.substr( _idxExt+1 )

		# TODO fix commands
		_cmds = []
		for cmd, _i in cmds
			_cmd = cmd
			for _name, _val of tmplData 
				_cmd = _cmd.replace( "{#{ _name.toUpperCase() }}", _val )
			_cmds.push( _cmd )

		[ _cmds, tmplData ]

	getDir: ( cb = -> )=>
		exec 'pwd', ( err, stdout, stderr )->
			cb( null, stdout.replace( /\n/, '' ) )
			return
		return

	getFiles: ( filter, cb )=>
		@getDir ( err, wdir )=>
			@_findFiles wdir, filter, cb
			return
		return

	_findFiles: ( directory, filter, cb )=>

		_cnf = @config

		files = []
		stack = [ directory ]
		fileRegex = new RegExp( filter, "ig" )

		next = =>
			if not stack.length
				cb( null, files )
			else
				dir = stack.pop()
				fs.stat dir, (err, stats)=>
					if err
						cb( err )
					else

						return next() unless stats.isDirectory

						fs.readdir dir, ( err, dirContents )=>
							if err
								cb( err )
							else
								for file in dirContents
									fullpath = path.join(dir, file)
									if file.indexOf( "." ) >= 0
										if fileRegex.test( file )
											files.push( fullpath )
									else if file.indexOf( "." ) is -1
										stack.push( fullpath )

								next()
							return
					return
		next()
		return

args = process.argv.slice( 2 )
dw = new DevWatch()
dw.watch( args[ 0 ], args.slice( 1 ) )