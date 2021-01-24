var path = require('path');
var fs = require('fs');
var { zipFiles } = require('jszip-glob');
var JSZip = require('jszip');

var baseDir = path.join(__dirname, '..', '..');
var modules = require('../../modules.json')

fs.readdir(baseDir, function (err, files) {
  if (err) {
    console.error("Could not list the directory.", err);
    process.exit(1);
  }
  files.forEach(function (file, index) {
    fs.stat(path.join(baseDir, file), function (error, stat) {
      if (error) {
        console.error("Error stating file.", error);
        return;
      }
      if (stat.isDirectory() && modules[file]) {
        zipFiles('**/*.*', {
          cwd: path.join(baseDir, file),
          dot: false,
          nodir: false,
          nosort: true,
          zip: new JSZip(),
          compression: 'DEFLATE',
          compressionOptions: {
            level: 6,
          },
        }).then(function(zip) {
          zip
            .generateNodeStream({ type:'nodebuffer', streamFiles:true })
            .pipe(fs.createWriteStream(path.join(baseDir, 'dist', file + '.zip')))
            .on('finish', function () {
                console.log('Spakowano moduł ' + file + '\n')
            });
        }).catch(function(err) {
          console.error(err);
        });        
      }
    });
  });
});
