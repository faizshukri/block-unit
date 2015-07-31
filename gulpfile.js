var elixir        = require('laravel-elixir'),
    gulp          = require('gulp'),
    templateCache = require('gulp-angular-templatecache'),
    inject        = require('gulp-inject'),
    del           = require('del'),
    bowerFiles    = require('main-bower-files'),
    wiredep       = require('wiredep');

elixir.config.assetsPath = 'src';
elixir.config.publicPath = '';


gulp.task('build', function(){
    elixir(function(mix) {

        //Clean first before build
        del(['./css/', './js/', './index.html']);

        // Cache the template
        gulp.src('src/coffee/**/*.html')
            .pipe(templateCache({module: 'app'}))
            .pipe(gulp.dest('js'));

        wiredep({src: 'src/sass/*'});

        mix
            .sass(
                '**/*.scss'
            )
            .coffee(
                '**/*.coffee'
            )
    });
});

gulp.task('inject', function(){
    // Inject the file to html
    var target = gulp.src('./src/index.html');
    // It's not necessary to read the files (will speed up things), we're only after their paths: 
    var sources = gulp.src(['./js/**/*.js', './css/**/*.css'], {read: false});

    target
        .pipe(wiredep.stream())
        .pipe(inject(sources))
        .pipe(gulp.dest('./'));
});

gulp.task('watch', ['default'], function(){
    gulp.watch('src/**/*', ['default']);
});

gulp.task('default', ['build', 'inject']);