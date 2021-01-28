var path = require('path');
var fs = require('fs');
var { zipFiles } = require('jszip-glob');
var JSZip = require('jszip');

var baseDir = path.join(__dirname, '..', '..');
var modules = require('../../modules.json')

fs.readdir(baseDir, function (err, files) {
  if (err) {
    console.error("Nie udało się odczytać folderów.", err);
    process.exit(1);
  }
  files.forEach(function (file, index) {
    fs.stat(path.join(baseDir, file), function (error, stat) {
      if (error) {
        console.error("Nie udało się odczytać danych pliku/folderu.", error);
        return;
      }
      if (stat.isDirectory() && modules[file]) {
        try {
          var module = JSON.parse(fs.readFileSync(path.join(baseDir, file, 'module.json')));
        } catch (err) {
          console.error("Nie udało się odczytać pliku module.json w katalogu " + file + ".", err);
          process.exit(1);      
        }
        if (modules[file].version == 0) {
          console.log("Pakiet " + file + " istnieje w repozytorium w wersji rozwojowej, nie buduję nowej paczki w dist.")
          return;
        }
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
            .on('finish', function (err) {
                if (err) {
                  console.err(err);
                  process.exit();
                }
                console.log('Spakowano moduł ' + file + '\n');
            });
        }).catch(function(err) {
          console.error(err);
        });        
      }
    });
  });
});
