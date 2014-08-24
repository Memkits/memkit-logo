
gulp = require 'gulp'
filetree = require 'make-filetree'
watch = require 'gulp-watch'
html = require 'gulp-cirru-html'
reloader = require 'gulp-reloader'
coffee = require 'gulp-coffee'
browserify = require 'gulp-browserify'
plumber = require 'gulp-plumber'
rsync = require('rsyncwrapper').rsync
uglify = require 'gulp-uglify'
rename = require 'gulp-rename'

project = 'memkits-logo'

gulp.task 'folder', ->
  filetree.make '.',
    coffee:
      'main.coffee': ''
    css:
      'style.css': ''
    cirru:
      'index.cirru': ''
    'README.md': ''
    build: {}
    js: {}

gulp.task 'watch', ->
  reloader.listen()

  gulp
  .src 'cirru/*'
  .pipe watch()
  .pipe (html data: {dev: yes})
  .pipe (gulp.dest './')
  .pipe (reloader project)

  gulp
  .src 'coffee/**/*.coffee'
  .pipe watch()
  .pipe plumber()
  .pipe (coffee bare: yes)
  .pipe (gulp.dest 'js/')

  watch glob: './js/**/*.js', ->
    gulp
    .src 'js/main.js'
    .pipe (browserify debug: yes)
    .pipe (gulp.dest 'build/')
    .pipe (reloader project)

gulp.task 'build', ->
  gulp
  .src 'coffee/*'
  .pipe (coffee bare: yes)
  .pipe (gulp.dest 'js/')

  gulp
  .src 'js/main.js'
  .pipe (browserify debug: no)
  .pipe uglify()
  .pipe(rename extname: '.min.js')
  .pipe (gulp.dest 'build/')

  gulp
  .src 'cirru/*'
  .pipe (html data: {dev: no})
  .pipe (gulp.dest '.')

gulp.task 'rsync', ->
  rsync
    ssh: yes
    src: '.'
    recursive: true
    args: ['--verbose']
    dest: "tiye:~/repo/#{project}"
    exclude: [
      'bower_components/'
      'node_modules/'
      'cirru/'
      '.gitignore'
      '.npmignore'
      'README.md'
      'coffee/'
      'js/'
      'gulpfile.coffee'
      '*.json'
    ]
  , (error, stdout, stderr, cmd) ->
    if error? then throw error
    if stderr?
      console.error stderr
    else
      console.log cmd