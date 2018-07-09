(function() {
    // テストするソースの読み込み
    var PersonJs = require('../person');

    // テストするクラス
    var Person = PersonJs.Person;

    // テストコード
    describe('Person Class', function(){
        it('exist Person Class', function() {
            expect(Person).toBeDefined();
        });
        it('create Person Object', function() {
            var person = new Person();
            expect(person).toNotEqual(null);
        });
        it('init Person Object', function() {
            var person = new Person();
            var name = person.getName();
            expect(name).toEqual('');
            var age = person.getAge();
            expect(age).toEqual(0);
        });
        it('setter test', function() {
            var person = new Person();
            var name = 'Toro_kun';
            var age = 0x20;
            person.setName(name);
            expect(person.getName()).toEqual(name);
            person.setAge(age);
            expect(person.getAge()).toEqual(age);
        });
    });
})();
