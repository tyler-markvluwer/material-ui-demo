var compileCoffeeScript = require('broccoli-coffee');
var compileCJSX = require('broccoli-cjsx');
var pickFiles = require('broccoli-funnel');
var mergeTrees = require('broccoli-merge-trees');
var browserify = require('broccoli-browserify');
// var compileSass = require('broccoli-sass');
var autoprefixer = require('broccoli-autoprefixer')

var js = compileCJSX('src/coffee');
js = compileCoffeeScript(js);
js = mergeTrees([js, 'src/js'], { overwrite: true });
js = browserify(js, {
  entries: ['./index.js'],
  outputFile: './bundle.js'
});

js = pickFiles(js, {
  srcDir: '/',
  destDir: 'js'
});

// var sass = compileSass(['src/sass'], '/index.sass', '/style.css');

// sass = pickFiles(sass,{
//   srcDir: '/',
//   destDir: '/css'
// });

// sass = autoprefixer(sass, {cascade:true});

var css = pickFiles('src/css',{
  srcDir: '/',
  destDir: '/css'
});

css = autoprefixer(css, {cascade:true});


var index = pickFiles('src/static', {
  srcDir: '/',
  destDir: '/'
});

// var fontawesomeFonts= pickFiles('node_modules/font-awesome/fonts', {
//     srcDir: '/',
//     destDir: '/fonts'
// });

// module.exports = mergeTrees([js, index, css, sass], {overwrite: true});
module.exports = mergeTrees([js, index, css], {overwrite: true});