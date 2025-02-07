const { checkAll } = require('./check_all');

const args = process.argv.slice(2);

if (args.includes('check-all')) {
    checkAll();
}
