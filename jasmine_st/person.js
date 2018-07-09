(function() {
    function Person() {
        this.name = '';
        this.age = 0;
    };
 
    Person.prototype.getName = function() {
        return this.name;
    };
 
    Person.prototype.setName = function(name) {
        this.name = name;
    };
 
    Person.prototype.getAge = function() {
        return this.age;
    };
 
    Person.prototype.setAge = function(age) {
        this.age = age;
    };
 
    exports.Person = Person;
})();

