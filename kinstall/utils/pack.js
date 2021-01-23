var path = require('path');
var fs = require('fs');
const { zipFiles } = require('jszip-glob');
const JSZip = require('jszip');

var name = process.argv[2];
var baseDir = path.join(__dirname, '..', '..');

if (!fs.existsSync(path.join(baseDir, name))) {
  console.error('Folder ' + name + ' nie istnieje w katalogu profilu.');
  process.exit(0);
}

zipFiles('**/*.*', {
  cwd: path.join(baseDir, name),
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
    .pipe(fs.createWriteStream(path.join(baseDir, name, name + '.zip')))
    .on('finish', function () {
        console.log('Spakowano moduł ' + name + '\n')
    });
}).catch(function(err) {
  console.error(err);
});
