//チェスのゲーム
class Game {
    private pieces = Game.makePieces()

    private static makePieces() {
        return [
            //キング
            new King('White', 'E', 1),
            new King('Black', 'E', 8)
        ]
    }
 }

//チェスの駒
abstract class Piece {
    protected position: Position
    constructor(
        private readonly color: Color,
        file: File,
        rank: Rank
    ) {
        this.position = new Position(file, rank)
    }
}

//駒
class King extends Piece { }
class Queen extends Piece { }
class Bishop extends Piece { }
class Knight extends Piece { }
class Rook extends Piece { }
class Pawn extends Piece { }

//駒の位置
class Position {
    constructor(
        private file: File,
        private rank: Rank
    ) {
        
    }
}

type Color = 'Black' | 'White'
type File = 'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H'
type Rank = 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8

//new Piece('White', 'E', 1)    エラー抽象クラスのインスタンスは作成できません


class Set {
    has(value: number): Boolean {
        return true
    }
    add(value: number): this {

    }
}

class MutableSet extends Set {
    delete(value: number): boolean {
        return true
    }
    add(value: number): MutableSet {

    }
}

let set = new Set
set.add(1).add(2).add(3)
set.has(2)
set.has(4)


interface Food {
    calories: number
    tasty: boolean
}

interface Sushi extends Food {
    salty: boolean
}

interface Cake extends Food {
    sweet: boolean
}

interface A {
    good(x: number): string
    bad(x: number): string
}

interface B extends A {
    good(x: string | number): string
    bad(x: string): string
}


interface User {
    name: string
}

interface User {
    age: number
}

let a: User = {
    name: 'Ashley',
    age: 30
}

//type User = { 識別子 `User` が重複しています
//    name: string
//}

//type User = { 識別子 `User` が重複しています
//    age: number
//}

//interface User<Age extends number> {   `User` のすべての宣言には同一の型パラメータがあり必要があります 
//    age: Age
//}

interface User<Age extends string> {
    age: Age
}


interface Animal {
     readonly name: string
    eat(food: string): void
    sleep(hours: number): void
}

interface Feline {
    meow(): void
}

class Cat implements Animal, Feline {
    name: 'Wiskers'
    eat(food: string) {
        console.info('Ate some', food, '. Memm!')
    }
    sleep(hours: number) {
        console.info('Slept for', hours, 'hours')
    }
    meow() {
        console.info('Meow')
    }
}


class Zebra {
    trot() {
        //
    }
}

class Poodle {
    trot() {
        //
    }
}

function ambleAround(animal: Zebra) {
    animal.trot()
}

let zebra = new Zebra;
let poodle = new Poodle

ambleAround(zebra)
ambleAround(poodle)

class A {
    private x = 1
}
class B extends A { }
function f(a: A) { }

f(new A)
f(new B)

//f({ x: 1 })   型 '{ x: number }' の引数を型 `A` のパラメータに割り当てることはできません


//値
let c = 1999
function b() { }

//型
type c = number
interface b {
    (): void
}

if (a + 1 > 3){ }
let x: a = 3

class D { }
let d: D = new D

enum E { F, G }
let e: E = E.F

type State = {
    [key: string]: string
}

class StringDatabse {
    state: State = {}
    get(key: string): string | null {
        return key in this.state ? this.state[key] : null
    }
    set(key: string, value: string): void {
        this.state[key] = value
    }
    static from(state: State) {
        let db = new StringDatabse
        for (let key in state) {
            db.set(key, state[key])
        }
        return db
    }
}

interface StringDatabseConstructor {
    new(): StringDatabse
    from(state: State): StringDatabse
}

class MyMap<K, V> {
    constructor(initialKey: K, initialValue: V) {
        //
    }
    get(key: K): V {
        //
    }
    set(key: K, vale: V): void {
        //
    }
    merge<K1, V1>(map: MyMap<K1, V1>): MyMap<K | K1 | K1, V | V1> {
        //
    }
    static of<K, V>(k: K, v: V): MyMap<K, V> {
        //
    }
}

interface MyMap<K, V> {
    get(key: K): V
    set(key: K, vslue: V): void
}

let aa = new MyMap<string, number>('K', 1)
let bb = new MyMap('K', true)

aa.get('k')
bb.set('k', false)

type ClassConstructor = new (...args: any[]) => {
    //
}

function withEZDebug<C extends ClassConstructor>(Class: C) {
    return class extends Class {
        constructor(...args: any[]) {
            super(...args)
        }
    }
}

class HardToDebugUser {
    constructor(
        private id: number,
        private firstName: string,
        private lastName: string
    ) { }
    getDebugValue() {
        return {
            id: this.id,
            name: this.firstName + ' ' + this.lastName
        }
    }
}

let User = withEZDebug(HardToDebugUser)
let user = new User(3, 'Ema', 'Gluzman')
user.getDebugValue()


class MessageQueue {
    private constructor(private messages: string[]) {  }
    static create(messages: string[]) {
        return new MessageQueue(messages)
    }
}

//class BadQueue extends MessageQueue { }  クラス `MessageQueue` を拡張できません。Class コンストラクターが privete に設定されています


type Shoe = {
    purpose: string
}

class BalletFlat implements Shoe {
    purpose = 'dancing'
}

class Boot implements Shoe {
    purpose = 'woodcutting'
}

class Sneaker implements Shoe {
    purpose = 'walking'
}

type ShoeCreator = {
    create(type: 'balletFlat'): BalletFlat
    create(type: 'boot'): Boot
    create(type: 'sneaker'): Sneaker
}

let Shoe: ShoeCreator = {
    create(type: 'balletFlat' | 'boot' | 'sneaker'): Shoe {
        switch (type) {
            case 'balletFlat': return new BalletFlat()
            case 'boot': return new Boot()
            case 'sneaker': return new Sneaker()
            
        }
    }
}


class RequestBuilder {
    protected data: object | null = null
    protected method: 'get' | 'post' | null = null
    protected url: string | null = null

    setMethod(method: 'get' | 'post'): RequestBuilderWithMethod {
        //this.method = method
        return new RequestBuilderWithMethod().setMethod(method).setData(this.data)
    }
    setData(data: object | null = null): this {
        this.data = data
        return this
    }
    //setUrl(url: string): this {
    //    this.url = url
    //    return this
    //}

    send() {
        //
    }
}

class RequestBuilderWithMethod extends RequestBuilder {
    setMethod(method: 'get' | 'post' | null): this {
        this.method = method
        return this
    }
    setUrl(url: string): RequestBuilderWithMethodAndURL {
        return new RequestBuilderWithMethodAndURL().setMethod(this.method).setUrl(url).setData(this.data)
    }
}

class RequestBuilderWithMethodAndURL extends RequestBuilderWithMethod {
    setUrl(url: string): this {
        this.url = url
        return this
    }
    send() {
        //
    }
}

interface BuildableRequest {
    data?: object
    method: 'get' | 'post'
    url: string
}

class RequestBuilder2 {
    data?: object
    method: 'get' | 'post'
    url: string

    setData(data: object): this & Pick<BuildableRequest, 'data'> {
        return Object.assign(this, { data })
    }

    setMethod(method: 'get' | 'post'): this & Pick<BuildableRequest, 'method'> {
        return Object.assign(this, { method })
    }

    setUrl(url: string): this & Pick<BuildableRequest, 'url'> {
        return Object.assign(this, { url })
    }

    build(this: BuildableRequest) {
        return this
    }
}

new RequestBuilder2()
    .setData({})
 //   .setMethod('post')  //これを削除すると
 //   .setUrl('bar')      //これを削除すると
    .build()