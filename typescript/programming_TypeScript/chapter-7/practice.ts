import { isDate } from "util"
import { SSL_OP_DONT_INSERT_EMPTY_FRAGMENTS, SSL_OP_SSLREF2_REUSE_CERT_TYPE_BUG } from "constants"
import { isMainThread } from "worker_threads"
import { NetConnectOpts } from "net"

function ask() {
    //return prompt('When is your birthday?')
    let result = prompt('When is your birthday?')
    if (result === null) {
        return []
    }
    return [result]
}

function parse(birthday: string): Date | null {
    let date = new Date(birthday)
    if (!isValid(date)) {
        //return null
        //throw new RangeError('Enter a date in the from YYYY/MM/DD')
        throw new InvalidDateFormatError('Enter a date in the from YYYY/MM/DD')
    }
    if (date.getTime() > Date.now()) {
        throw new DateIsTheFutureError('Are you a timelord?')
    }
    return date
}

function isValid(date: Date) {
    return Object.prototype.toString.call(date) === '[object Date]' &&!Number.isNaN(date.getTime())
}

try {
    let date = parse(ask())
    if (date) {
        console.info('Date is', date.toISOString())
    } else {
        console.error('Error parsing date for some reazon')
    }
} catch (e) {
    //console.error(e.message)
    if (e instanceof RangeError) {
        console.error(e.message)
    } else if (e instanceof DateIsTheFutureError) {
        console.error(e.message)
    }else {
        throw e
    }
}

//カスタムエラー
class InvalidDateFormatError extends RangeError { }
class DateIsTheFutureError extends RangeError { }

function parse2(
    birthday: string  
): Date | InvalidDateFormatError | DateIsTheFutureError {
    let date = new Date(birthday)
    if (!isValid(date)) {
        return new InvalidDateFormatError('Enter a date in the from YYYY/MM/DD')
    }
    if (date.getTime() > Date.now()) {
        return new DateIsTheFutureError('Are you a timelord?')
    }
    return date
}

let result = parse2(ask())
if (result instanceof InvalidDateFormatError) {
    console.error(result.message)
} else if (result instanceof DateIsTheFutureError) {
    console.error(result.message)
} else {
    console.info('Date is', result?.toISOString)
}

function parse3(birthday: string): Date[] {
    let date = new Date(birthday)
    if (!isValid(date)) {
        return []
    }
    return [date]
}

let date = parse3(ask())
date
    .map(_ => _.toISOString())
    .forEach(_ => console.info('Date is', _))

flatten(ask())
    .map(parse3))
    .map(date => date.toISOString())
    .forEach(date => console.info('Date is', date))


function flatten<T>(array: T[][]): T[] {
    return Array.prototype.concat.apply([], array)
}


interface Option<T> { 
    flatMap<U>(f: (value: T) => None): None
    flatMap<U>(f: (value: T) => Option<U>): Option<U>
    getOrElse(value: T): T
}
class Some<T> implements /*extends*/ Option<T> {
    constructor(private value: T) { }
    flatMap<U>(f: (value: T) => None): None
    flatMap<U>(f: (value: T) => Some<U>): Some<U>
    flatMap<U>(f: (value: T) => Option<U>): Option<U> {
        return f(this.value)
    }
    getOrElse(): T {
        return this.value
    }
}
class None implements /*extends*/ Option<never> {
    /*flatMap<U>(): Option<U> {
        return this
    }*/
    flatMap(): None {
        return this
    }
    getOrElse<U>(value: U): U {
        return value
    }
}

function Option<T>(value: null | undefined): None
function Option<T>(value: T): Some<T>
function Option<T>(value: T): Option<T> {
    if (value === null) {
        return new None
    }
    return new Some(value)
}



type UserID = unknown

//次に示す API に関するエラーの処理方法を設計してください
declare class API {
    getLoggedInUserID(): Option<UserID>
    getFriendIDs(userID: UserID): Option<UserID[]>
    getUserName(userID: UserID): Option<string>
}

interface Option<T> {
    flatMap<U>(f: (value: T) => None): None
    flatMap<U>(f: (value: T) => Option<U>): Option<U>
    getOrElse(value: T): T
}
class Some<T> implements Option<T> {
    constructor(private value: T) { }
    flatMap<U>(f: (value: T) => None): None
    flatMap<U>(f: (value: T) => Some<U>): Some<U>
    flatMap<U>(f: (value: T) => Option<U>): Option<U> {
        return f(this.value)
    }
    getOrElse(): T {
        return this.value
    }
}
class None implements Option<never> {
    flatMap(): None {
        return this
    }
    getOrElse<U>(value: U): U {
        return value
    }
}

function listOfOptionsToOptionOfList<T>(list: Option<T>[]): Option<T[]> {
    let empty = {}
    let result = list.map(_ => _.getOrElse(empty as T)).filter(_ => _ !== empty)
    if (result.length) {
        return new Some(result)
    }
    return new None()
}

let api = new API()
let friendUserNames = api
    .getLoggedInUserID
    .flatMap(api.getFriendIDs)
    .flatMap(_ => listOfOptionsToOptionOfList(_.map(api.getUserName)))
