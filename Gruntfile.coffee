'use strict'
path = require('path')
# lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet

folderMount = (connect, point) ->
	return connect.static(path.resolve(point))


module.exports = (grunt) ->

	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')

		uglify:
			options:
				mangle: false
				preserveComments: 'some'
				banner: '/*! <%= pkg.name %> - v<%= pkg.version %>  */'
			script:
				files:
					'js/script.min.js' : [
						'js/libs/jquery-2.0.3.min.js',
						# 'js/libs/snap-svg.min.js',
						'js/plugins/typogr.js',
						'js/plugins/hisrc.js',
						'js/plugins/imageloader.js',
						'js/script.js']
			touch:
				files:
					'js/script-touch.min.js' : [
						'js/libs/jquery-2.0.3.min.js',
						# 'js/libs/snap-svg.min.js',
						'js/plugins/typogr.js',
						'js/plugins/hisrc.js',
						'js/plugins/imageloader.js',
						'js/plugins/touchswipe.js',
						'js/touch.js',
						'js/script.js']
			init:
				files:
					'js/init.min.js' : [
						'js/libs/modernizr.min.js',
						'js/init.js']

		jshint:
			options:
				"camelcase" : false
				"es3" : false
				"trailing" : false
				"white" : false
				"smarttabs" : true
				"jquery" : true
				"browser" : true
			files:[
				'js/init.js',
				'js/touch.js',
				'js/script.js'
				]


		sass:
			options:
				compass: 'config.rb'
				style: 'compressed'
				debugInfo: true
				trace:     true
				sourcemap: true
			local:
				files:
					"css/style.css" : "sass/style.sass"
			prod:
				options:
					sourcemap: false
				files:
					"css/style.css" : "sass/style.sass"


		autoprefixer:
			local:
				options:
					map: true
				src: 'css/*.css'
			prod:
				options:
					map: false
				src: 'css/*.css'

		# "merge-json":
		# 	local:
		# 		files:
		# 			'data/index.json' :     ['data/env/local.json', 'data/page/index.json']
		# 			'data/portfolio.json' : ['data/env/local.json', 'data/page/portfolio.json']
		# 			'data/students.json' :  ['data/env/local.json', 'data/page/students.json']
		# 	stage:
		# 		files:
		# 			'data/index.json' :     ['data/env/stage.json', 'data/page/index.json']
		# 			'data/portfolio.json' : ['data/env/stage.json', 'data/page/portfolio.json']
		# 			'data/students.json' :  ['data/env/stage.json', 'data/page/students.json']
		# 	prod:
		# 		files:
		# 			'data/index.json' :     ['data/env/prod.json', 'data/page/index.json']
		# 			'data/portfolio.json' : ['data/env/prod.json', 'data/page/portfolio.json']
		# 			'data/students.json' :  ['data/env/prod.json', 'data/page/students.json']


		jade:
			options:
				pretty: true
			index:
				options:
					data: (dest, src) -> return require('./data/index.json')
				files:
					'index.html' : 'jade/index.html.jade'

		yaml:
			options:
				space: 2
			pages: 
				files:
					'data/index.json': ['data/index.yml']

		watch:
			sass:
				options:
					livereload: true
				files: ['sass/**/*.sass', 'sass/**/*.scss']
				tasks: ['sass:local', 'autoprefixer:local']

			jade:
				files: ['jade/**/*.jade', 'data/**/*.json']
				tasks: ['jade']

			image:
				files: ['img/*']
				options:
					livereload: true
			html:
				files: ['*.html']
				options:
					livereload: true
			js:
				files: ['js/script.js', 'js/touch.js']
				tasks: ['jshint', 'uglify:script', 'uglify:touch']
			initjs:
				files: ['js/init.js']
				tasks: ['jshint', 'uglify:init']
			jsmin:
				files: ['js/script.min.js', 'js/init.min.js']
				options:
					livereload: true
			css:
				files: ['css/**/*']
				options:
					livereload: true
			yaml:
				files: ['data/**/*.yml']
				tasks: ['yaml']

		connect:
			server:
				options:
					port: 9001



	require('load-grunt-tasks')(grunt);


	# Environments
	grunt.registerTask('local', ['sass:local', 'autoprefixer:local', 'yaml', 'jade'])
	grunt.registerTask('stage', ['sass:prod',  'autoprefixer:prod',  'yaml', 'jade'])
	grunt.registerTask('prod',  ['sass:prod',  'autoprefixer:prod',  'yaml', 'jade'])

	# Default task(s).
	grunt.registerTask('compile', ['sass:local', 'autoprefixer:local', 'jade'])
	grunt.registerTask('default', ['compile', 'connect', 'watch'])