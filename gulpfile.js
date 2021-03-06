var gulp          = require('gulp'),
    templateCache = require('gulp-angular-templatecache'),
    inject        = require('gulp-inject'),
    wiredep       = require('wiredep').stream,
    sass          = require('gulp-sass'),
    coffee        = require('gulp-coffee'),
    concat        = require('gulp-concat'),
    clean         = require('gulp-clean'),
    gulpif        = require('gulp-if'),
    uglify        = require('gulp-uglify'),
    uglifycss     = require('gulp-uglifycss'),
    rename        = require("gulp-rename"),
    argv          = require('yargs').argv,
    livereload    = require('gulp-livereload');

var path = {
    'assets' : 'src',
    'public' : 'public',
    'vendor' : 'public/vendor'
};

gulp.task('build', ['clean', 'cacheTemplate', 'sass', 'css', 'coffee', 'scripts', 'copyAssets', 'clean:after']);

gulp.task('clean', function(){
    //Clean first before build
    return gulp.src([path.public+'/css/', path.public+'/js/', path.public+'/index.html', path.public+'/fonts/'], {read: false})
        .pipe(clean({force: true}));
});

gulp.task('clean:after', ['copyAssets'], function(){
    return gulp.src(path.public+'/build/')
        .pipe(clean({force: true}))
});

gulp.task('cacheTemplate', ['clean'], function(){
    // Cache the template
    return gulp.src(path.assets+'/coffee/**/*.html')
        .pipe(templateCache({module: 'app'}))
        .pipe(gulpif(argv.production, uglify()))
        .pipe(gulpif(argv.production, rename({suffix: '.min'})))
        .pipe(gulp.dest(path.public+'/js'))
});

gulp.task('sass', ['clean'], function () {
    return gulp.src(path.assets + '/sass/**/*.scss')
        .pipe(wiredep())
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest(path.public + '/build/css'));
});

gulp.task('css', ['sass'], function(){
    return gulp.src([path.public+'/build/css/**/*.css', path.assets+'/css/**/*.css'])
        .pipe(concat('app.css'))
        .pipe(gulpif(argv.production, uglifycss()))
        .pipe(gulpif(argv.production, rename({suffix: '.min'})))
        .pipe(gulp.dest(path.public + '/css'))
});

gulp.task('coffee', ['clean'], function() {
    return gulp.src(path.assets + '/coffee/**/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest(path.public + '/build/js'))
});

gulp.task('scripts', ['coffee'], function() {
    return gulp.src([path.public+'/build/js/**/*.js', path.assets + '/js/**/*.js'])
        .pipe(concat('app.js'))
        .pipe(gulpif(argv.production, uglify()))
        .pipe(gulpif(argv.production, rename({suffix: '.min'})))
        .pipe(gulp.dest(path.public + '/js'))
});

gulp.task('copyAssets', ['clean', 'css'], function(){
    return gulp.src(path.vendor + '/bootstrap/fonts/**/*')
        .pipe(gulp.dest(path.public + '/fonts/bootstrap'))
});

gulp.task('inject', ['build'], function(){

    // Inject the file to html
    var target = gulp.src('./src/index.html');
    // It's not necessary to read the files (will speed up things), we're only after their paths: 
    var sources = gulp.src(['public/js/**/*.js', 'public/css/**/*.css'], {read: false});

    target
        .pipe(wiredep({ignorePath: '../public'}))
        .pipe(inject(sources, {ignorePath: '/public'}))
        .pipe(gulp.dest('public'))
});

gulp.task('watch', ['default'], function(){
    livereload({ start: true })
    gulp.watch('src/**/*', ['default'])
});

gulp.task('default', ['build', 'inject'])