//サーバから取得した既存のユーザ
type ExistingUser = {
    id: number
    name: string
}

//サーバにまだ保存されていない新規のユーザ
type NewUser = {
    name: string
}

function deleteUser(user: { id?: number, name: string }) {
    delete user.id
}

let existingUser: ExistingUser = {
    id: 123456,
    name: 'Ima USer'
}

deleteUser(existingUser)

type LegacyUser = {
    id?: number | string
    name: string
}

let legacyUser: LegacyUser = {
    id: '987654',
    name: 'Xin Yang'
}

deleteUser(legacyUser)  //`legacyUaser` の引数を型 `{ id?: number | undefined; name: storing }` のパラーメータに割り当てることはできません

class Animal { }

class Bird extends Animal {
    chirp() {  }
}

class Crow extends Bird {
    caw() {  }
}

function chirp(bird: Bird): Bird {
    bird.chirp()
    return bird
}

chirp(new Animal)   //型 `Animal` の引数に `Bird` のパラメータを割り当てることはできません
chirp(new Bird)
chirp(new Crow)

function clone(f: (b: Bird) => Bird): void {
    //
    let parent = new Bird
    let babyBird = f(parent)
    babyBird.chirp()
}

function birdToBird(b: Bird): Bird {
    //
}
clone(birdToBird)

function birdToCrow(d: Bird): Crow {
    //
}
clone(birdToCrow)

function birdToAnimal(d: Bird): Animal {
    //
}
clone(birdToAnimal) //型 `(d: Bird) => Animal` の引数を型 `(b: Bird) => Bird` のパラメータに割り当てることはできません

function animalToBird(a: Animal): Bird {
    //
}
clone(animalToBird)

function crowToBird(c: Crow): Bird {
    //
    c.caw()
    return new Bird
}
clone(crowToBird)

type Options = {
    baseUrl: string
    cacheSize?: number
    tier?: 'prod' | 'dev'
}

class Api {
    constructor(private options: Options) {  }
}

new Api({
    baseUrl: 'http://api.mysite.com',
    tier: 'prod'
})

new Api({
    baseUrl: 'http://api.mysite.com',
    badTier: 'prod'
})

new Api({
    baseUrl: 'http://api.mysite.com',
    tier: 'prod'
} as Options)

let badOptions = {
    baseUrl: 'http://api.mysite.com',
    badTier: 'prod'
}
new Api(badOptions)

let options: Options = {
    baseUrl: 'http://api.mysite.com',
    badTier: 'prod'
}
new Api(options)


//文字列リテラルの合併型を使って CSS の単位が取りうる値を表現します
type Unit = 'cm' | 'px' | '%'

//単位を列挙します
let units: Unit[] = ['cm', 'px', '%']

//各単位をチェックし、一致するものがなければ null を返します
function parseUnit(value: string): Unit | null {
    for (let i = 0; i < units.length; i++) {
        if (value.endsWith(units[i])) {
            return units[i]
        }
    }
    return null
}

type Width = {
    unit: Unit
    value: number
}

function parceWidth(width: number | string | null | undefined): Width | null {
    //width が null もしくは undefined であった場合はすぐに戻ります
    if (width == null) {
        return null
    }

    //with がピクセルであればピクセルをデフォルトの単位とします
    if (typeof width === 'number') {
        return { unit: 'px', value: width }
    }

    //width から単位を解析します
    let unit = parseUnit(width)
    if (unit) {
        return { unit, value: parceWidth(width) }
    }

    //どれでもなければ null を返す
    return null
}


//type UserTextEvent = { value: string, target: HTMLInputElement }
type UserTextEvent = { type: 'TextEvent', value: string, target: HTMLInputElement }
//type UserMouseEvent = { value: [number, number], target: HTMLElement }
type UserMouseEvent = { type: 'MouseEvent', value: [number, number], target: HTMLElement }

type UserEvent = UserTextEvent | UserMouseEvent

function handle(event: UserEvent) {
    /* if (typeof event.value === 'string') {
        event.value     //string
        event.target    //HTMLInputELement | HTMLElement (!!!)
        //
        return
    } */
    if (event.type === 'TextEvent') {
        event.value     //string
        event.target    //HTMLInputELement
        //
        return
    }
    event.value         //[number, number]
    event.target        //HTMLInputELement | HTMLElement (!!!)
}


type Weekday = 'Mon' | 'Tue' | 'Wed' | 'Thu' | 'Fri'
type Day = Weekday | 'Sat' | 'Sun'

function getNextDay(w: Weekday): Day {
    switch (w) {
        case 'Mon': return 'Tue'
    }
}

//let nextDay: Record<Weekday, Day> = {
//    Mon: 'Tue'
//}
let nextDay: { [K in Weekday]: Day } = {
    Mon: 'Tue'
}

type MyMappedType = {
    [Key in UnionType]: ValueType
}

type Account = {
    id: number
    isEmployee: Boolean
    notes: string[]
}

//すべてのフィールドを省略可能にします
type OptionalAccount = {
    [K in keyof Account]?: Account[K]
}

//すべてフィールドを null 許容にします
type NullableAccount = {
    [K in keyof Account]?: Account[K] | null
}

//すべてのフィイールドを読み取り専用にします
type ReadonlyAccount = {
    [K in keyof Account]: Account[K]
}

//すべてのフィールドを再び書き込み可能にします
type Account2 = {
    -readonly [K in keyof ReadonlyAccount]: Account[K]
}

//すべてのフィールドを再び必須にします(Account と同等)
type Account3 = {
    [K in keyof OptionalAccount]-?: Account[K]
}


function isBig(n: number) {
    if (n >= 100) {
        return true
    }
}


type ApiResponse = {
    user: {
        userId: string
        friendLinst: /* FriendList */ {
            count: number
            friends: {
                firstName: string
                lastName: string
            }
        }
    }
}

type FriendList = ApiResponse['user']['friendLinst'] /* {
    count: number
    friends: {
        firstName: string
        lastName: string
    } */
}


function getApiResponse(): Promise<ApiResponse> {
    //
}

function renderFriendList(friendList: undefined) {
    //
}

let response = await getApiResponse()
renderFriendList(response.user.friendLinst)


type RespoinseKeys = keyof ApiResponse                          // `user` 
type UserKeys = keyof ApiResponse['user']                       // `userId` | `friendList`
type FrienListKey = keyof ApiResponse['user']['friendLinst']    // `count` | `friends`

function get<
    O extends object,
    K extends keyof O
>(
    o: O,
    k: K
): O[K] {
    return o[k]
}

type ActiveLog = {
    lastEvent: Date
    events: {
        id: string
        timestamp: Date
        type: 'Read' | 'Write'
    }[]
}

let activityLog: ActiveLog =                    //
let lastEvent = get(activityLog, 'lastEvent')   //Date

function Get = {
    <
        O extends object
        K1 extends keyof O
    >(o: O, k1: K1): O[K1]
    <
        O extends object
        K1 extends keyof O
        k2 extends keyof O[K1]
    >(o: O, k1: K1, k2: K2): O[K1][K2]
    <
        O extends object
        K1 extends keyof O
        k2 extends keyof O[K1]
        k3 extends keyof O[K1][K2]
    >(o: O, k1: K1, k2: K2, k3: K3): O[K1][K2][K3]
}

let get: Get = (object: any, ...keys: string[]) => {
    let result = object
    keys.forEach(k => result = result[k])
    return result
}

get(activityLog, 'events', 0, 'type')   // `Read` 、 `Wtite`

get(activityLog, 'bad')     //型 `"bad"` の引数を型 `"lastEvent" | "events"` のパラメータに割り当てることはできません

type Unit = 'EUR' | 'GBP' | 'JPY' | 'USD'

type Currency = {
    unit: Unit
    value: number
}

let Currency = {
    from(value: number, unit: Unit): Currency {
        return {
            unit: unit,
            value
        }
    }
}

//let a = [1, true]   // (number | boolean)[]

function tuple<
    T extends unknown[]
>(
    ...ts: T
): T {
    return ts
}

let a = tuple(1, true)   // (number | boolean)[]

function isString(a: unknown): /* boolean */ a is string {
    return typeof a === 'string'
}

isString('a')       //true
isString([7])       //false

function parseInput(input: string | number) {
    let formattedInput: string
    if (isString(input)) {
        formattedInput = input.toUpperCase()
    }
}

type IsString<T> = T extends string
    ? true
    : false

//type A = IsString<string>   //true
//type B = IsString<number>   //false

type ToArray<T> = T[]
type A = ToArray<number>            //number[]
type B = ToArray<number | string>   //number | string

type Whithout<T, U> = T extends U ? never : T

type A = Whithout<boolean | number | string, boolean>   //number | string

type ElementType<T> = T extends unknown[] ? T[number] : T
type A = ElementType<number[]>  //number

type ElementType2<T> = T extends (infer U)[] ? U : T
type B = ElementType2<number[]> //number

Exclude<T, U>

    type A = number | string
    type B = string
    type C = Exclude<A, B>      //number

Extract < T, U >
    
    type A = number | string
    type B = string
    type C = Extract<A, B>      //string
    
NonNullable<T>
    type A = { a?: number | null }
    type B = NonNullable<A['a']>    //number
    
ReturnType<F>
    type F = (a: number) => string
    type R = ReturnType<F>      //string
    
InstanceType<C>
    type A = { new(): B }
    type B = { b: number }
type I = InstanceType<A>    //{ b: number } 
    

function formatInput(input: string) {
    //
}

function getUserInput(): string | number {
    //
}

formatInput(input as string)
formatInput(<string>input)


type Dialog = VisibleDialog | DestroyedDialog /* {
    id?: string
} */

type VisibleDialog = { id: string }
type DestroyedDialog = {  }


function closeDialog(dialog: Dialog) {
    /* if (!dialog.id) {
        return
    } */
    if (!('id' in dialog)) {
        return
    }
    setTimeout(() =>
        removeFromDom(
            dialog,
            document.getElementById(dialog.id!)!
        )
    )
}

function removeFromDom(dialog: VisibleDialog/* Dialog */, element: Element) {
    element.parentNode!.removeChild(element)
    delete dialog.id
}


let userId: string
userId.toUpperCase()

function fetchUser() {
    //userId = globalCache.get('userId')
    return globalCache.get('userId')
}


type CompanyId = string & { readonly brand: unique symbol }
type OrderId = string & { readonly brand: unique symbol }
type UserId = string & { readonly brand: unique symbol }
type Id = CompanyId | OrderId | UserId

function CompanyId(id: string) {
    return id as CompanyId
}

function OrderId(id: string) {
    return id as OrderId
}

function UserId(id: string) {
    return id as UserId
}

let companyId = CompanyId('8a6076cf')
let orderId = OrderId('9994cc1')
let userId = UserId('023b3dbf')

queryForUse(userId)
queryForUse(companyId)


//.zip について TypeScript に伝えます
interface Array<T> {
    zip<U>(list: U[]): [T, U][]
}

//.zip を実装します
Array.prototype.zip = function (list) {
    return this.map((v, k) =>
        [v, list[k]]
    )
}

/*
6.10
*/

//1

//a 1と number number は1を含むので可
//b number と1 number は1以外も含むので不可
//c string と number | string  string は number | string に含まれるので可
//d boolean と number　number は boolean を含まないので不可
//e number[]と(number | string)[] number[]は(number | string)[]に含まれるので可
//f (number | string)[]と number[] (number | string)[]には number[]以外も含まれるので不可
//g {a: true}と{a: boolean} {a: boolean}は{a: true}を含むので可
//h {a: {b: [string]}}と{a: {b: [number | string]}} {a: {b: [number | string]}}は{a: {b: [string]}}を含むので可
//i (a: number) => string と(b：number) => string 両者はイコールなので可
//j (a: number) => string と(a: string) => string 型が異なるので不可
//k (a: number | string) => string と(a: string) => string (a: number | string)は(a: string)を含むので可
//i (列挙型 enum E {X = 'X'}で定義されてている)E.X と(列挙型 enum F {X = 'X'}で定義されてている)F.X
enum E { X = 'X' }
enum F { X = 'X' }

let ee = E
let ff = F

//2
type O = { a: { b: { c: string } } }
type KeyOfO = keyof O               //a
type KeyOfA = keyof O['a']          //b
type KeyOfAb = keyof O['a']['b']    //c

//3
type Excrusive<T, U> = Exclude<T, U> | Exclude<U, T>

type RR = Excrusive<1 | 2 | 3, 2 | 3 | 4>
type UU = Excrusive<1 | 2, 2 | 4>


//4
let globalCache = {
    get(key: string) {
        return 'user'
    }
}

let userId = fetchUser()