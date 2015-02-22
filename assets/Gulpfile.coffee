sources =
  bower:  'bower.json'
  coffee: './cs/**/*.coffee'
  sass:   './sass/**/*.sass'
  js: ['./phoenix.js']

libs =
  js: []
  css: ['bootstrap/dist/css/bootstrap.min.css']

bower  = require 'bower'
del    = require 'del'
gulp   = require 'gulp'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
sass   = require 'gulp-sass'
uglify = require 'gulp-uglify'


gulp.task 'default', ['clean'], ->
  gulp.start 'compile:lib', 'compile:coffee', 'compile:sass', 'phoenix_js'

gulp.task 'clean', (cb) ->
  del ['../priv/static/css', '../priv/static/js'], force: true, cb

gulp.task 'watch', ->
  gulp.watch sources.bower,  ['compile:lib']
  gulp.watch sources.coffee, ['compile:coffee']
  gulp.watch sources.sass,   ['compile:sass']


gulp.task 'compile:lib', ->
  bower.commands.install().on 'end', ->
    gulp.src libs.js.map (e) -> "bower_components/#{e}"
        .pipe concat 'lib.js'
        .pipe gulp.dest '../priv/static/js/'
    gulp.src libs.css.map (e) -> "bower_components/#{e}"
        .pipe concat 'lib.css'
        .pipe gulp.dest '../priv/static/css/'

gulp.task 'compile:coffee', ->
  gulp.src sources.coffee
    .pipe coffee()
    .pipe uglify()
    .pipe concat 'app.js'
    .pipe gulp.dest '../priv/static/js/'

gulp.task 'compile:sass', ->
  gulp.src sources.sass
      .pipe sass()
      .pipe concat 'app.css'
      .pipe gulp.dest '../priv/static/css/'

gulp.task 'phoenix_js', ->
  gulp.src sources.js
      .pipe gulp.dest '../priv/static/js/'
