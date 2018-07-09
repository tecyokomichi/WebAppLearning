var assert = require('assert');
var main = require('../main');

describe('main', function () {
    describe('greet', function () {
        it('引数に応じて決まった文字列を返すこと', function () {
            assert.equal(main.greet('taro'), 'Hello,taro');
        });
    });

    describe('greetAsync', function () {
        it('引数に応じてコールバック内で決まった文字列になること', function (done) {
            main.greetAsync('hanako', function (greet) {
                assert.equal(greet, 'Hello,hanako');
                done();
            });
        });
    });
});
