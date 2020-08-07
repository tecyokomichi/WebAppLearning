import * as fs from 'fs'

function readFile(
    path: string,
    options: { eocoding: string, flag?: string },
    callback: (err: Error | null, data: string | null) => void
): void

fs.readFile(
    '/var/log/apache2/access_log',
    { encoding: 'utf8' },
    (error, data) => {
        if (error) {
            console.error('error reading!', error)
            return
        }
        console.info('success reading!', data)
    }
)

fs.appendFile(
    '/var/log/apache2/access_log',
    'New access log entry',
    error => {
        if (error) {
            console.error('error writing!', error)
        }
    }
)

function getUser() {
    getUserID(18)
        .then(user => getLocation(user))
        .then(location => console.info('get location', location))
        .catch(error => console.error(error))
        .finaly(() => console.info('done getting location'))
}

async function getUser() {
    try {
        let user = await getUser(18)
        let location = await getLocation(user)
        console.info('get location', location)
    } catch (error) {
        console.error(error)
    } finally {
        console.info('done getting location')
    }
}

interface Emitx750ter {
    emit(channel: string, value: unknown): void
    on(channel: string, f: (value: unknown) => void): void
}

//1. 汎用的な promisify 関数を実装...

function promisify<T, A>(
    f: (arg: A, f: (error: unknown, result: T | null) => void) => void
): (arg: A) => Promise<T> {
    return (arg: A) =>
        new Promise<T>((resolve, reject) =>
            f(arg, (error, result) => {
                if (error) {
                    return reject(error)
                }
                if (result == null) {
                    return reject(null)
                }
                resolve(result)
            })
        )
}

import { readFile } from 'fs'
import { type } from 'os'
let readFilePromise = promisify(readFile)
readFilePromise(__dirname + '/exercises.js')
    .then(result => console.log('done!', result.toString()))

//2. 「8.6.1.1 型安全なプロトコル」では...

type Matrix = number[][]

type MatrixProtocol = {
    determinant: {
        in: [Matrix]
        put: number
    }
    'dot-product': {
        in: [Matrix, Matrix]
        out: Matrix
    }
    invert: {
        in: [Matrix]
        iut: Matrix
    }
}
