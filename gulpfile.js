var elixir        = require('laravel-elixir'),
    gulp          = require('gulp'),
    templateCache = require('gulp-angular-templatecache'),
    inject        = require('gulp-inject'),
    del           = require('del'),
    bowerFiles    = require('main-bower-files'),
    wiredep       = require('wiredep');

elixir.config.assetsPath = 'src';
elixir.config.publicPath = 'public';


gulp.task('build', function(){
    elixir(function(mix) {

        //Clean first before build
        del(['public/css/', 'public/js/', 'public/index.html', 'public/fonts']);

        // Cache the template
        gulp.src('src/coffee/**/*.html')
            .pipe(templateCache({module: 'app'}))
            .pipe(gulp.dest('public/js'));

        wiredep({src: 'src/sass/*'});

        mix
            .sass(
                '**/*.scss'
            )
            .coffee(
                '**/*.coffee'
            )
            .scripts(
                '**/*.js'
            )
            .copy(
                'public/vendor/bootstrap/fonts',
                'public/fonts/bootstrap'
            );
    });
});

gulp.task('inject', function(){
    // Inject the file to html
    var target = gulp.src('./src/index.html');
    // It's not necessary to read the files (will speed up things), we're only after their paths: 
    var sources = gulp.src(['public/js/**/*.js', 'public/css/**/*.css'], {read: false});

    target
        .pipe(wiredep.stream({ignorePath: '../public'}))
        .pipe(inject(sources, {ignorePath: '/public'}))
        .pipe(gulp.dest('public'));
});

gulp.task('watch', ['default'], function(){
    gulp.watch('src/**/*', ['default']);
});

gulp.task('default', ['build', 'inject']);