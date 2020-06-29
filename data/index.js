const csvFilePath = './centros.csv'
const csv = require('csvtojson')
const fs = require("fs");
const writeStream = fs.createWriteStream('createCenters.sh');
const pathName = writeStream.path;
csv()
  .fromFile(csvFilePath)
  .then((jsonObj) => {
    const centros = jsonObj.map((centro) => {
      const url = `https://${centro.url}.aeducar.es`
      const shortName = centro.longName.substring(0, centro.longName.indexOf("(") - 1)
      return { url, shortName, longName: centro.longName, deployType: centro.deployType }
    }).filter(centro => centro.deployType !== 'VACIO')

    centros.forEach(centro => writeStream.write(`createMoodle.sh -l es -n "${centro.longName}" -t "${centro.deployType}" -u "${centro.url}" "${centro.shortName}" \nsleep 5m\n`));

    // the finish event is emitted when all data has been flushed from the stream
    writeStream.on('finish', () => {
      console.log(`wrote all the array data to file ${pathName}`);
    });

    // handle the errors on the write process
    writeStream.on('error', (err) => {
      console.error(`There is an error writing the file ${pathName} => ${err}`)
    });

    // close the stream
    writeStream.end();
  })