# jszip-glob

Zip files by [Glob](https://github.com/isaacs/node-glob#readme)-pattern for [JSZip](https://stuk.github.io/jszip/).

## Installation

```
npm i jszip-glob
```

## Usage

``` javascript
const { zipFiles } = require('jszip-glob');
const JSZip = require('jszip');

zipFiles('glob/**/pattern', {
  /*
   * glob options.
   */
  cwd: 'path/to/directory',
  dot: false,
  nodir: true,
  nosort: true,
  ignore: 'exclude/**/pattern',

  /*
   * JSZip instance.
   */
  zip: new JSZip(),

  /*
   * JSZip options.
   */
  compression: 'DEFLATE',
  compressionOptions: {
    level: 6,
  },
}, (err, zip) => {
  // Do something
});
```

## License

MIT
