var replace = require('replace-in-file');
var cpy = require('cpy');
var fs = require('fs');
var path = require('path');
var remove = require('remove');

var name = process.argv[2];
var baseDir = path.join(__dirname, '..', '..')

if (fs.existsSync(path.join(baseDir, name))) {
  console.error('Folder ' + name + ' już istnieje w katalogu profilu.\n');
  process.exit(0);
}

var templateDir = path.join(baseDir, 'kinstall', 'template');
var templateCopyDir = path.join(baseDir, 'kinstall', 'tmp', 'template');

fs.mkdirSync(templateCopyDir, { recursive: true });
cpy(
  path.join(templateDir, '**', '*.*'),
  templateCopyDir
).then(function(){
  process.chdir(templateCopyDir);
  const options = {
    files: '*',
    from: /template/g,
    to: name,
  };
  try {
    const results = replace.sync(options);
    fs.mkdirSync(path.join(baseDir, name), { recursive: true });
    cpy(
      path.join(templateCopyDir, '**', '*.*'),
      path.join(baseDir, name)
    ).then(function(){
      remove(path.join(templateCopyDir), function(err) {
        if (err) {
          console.error(err);
        } else {
          console.log('Stworzono nowy moduł ' + name)
          if (fs.existsSync(path.join(baseDir, '.gitignore'))) {
            fs.appendFileSync(path.join(baseDir, '.gitignore'), '\n!/' + name + '/');
            console.log('Dodano wpis "' + name + '" do .gitignore by dodać moduł do brancha.');
          }
          console.log('\n');
        }
      });
    }).catch(function(){
      console.error(error);
    });
  }
  catch (error) {
    console.error(error);
  }    
}).catch(function(e) {
  console.error(err);
});
