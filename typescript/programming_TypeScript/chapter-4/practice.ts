//すぐに出発する旅行を予約する機能

type Reservation = unknown

type Reserve = {
    (from: Date, to: Date, destination: string): Reservation
    (from: Date, destination: string): Reservation
    (destination: string): Reservation
}

let reserve: Reserve = (
    fromOrDestination: Date | string,
    toOrDestination: Date | string,
    destination?: String
) => {
    if (
        fromOrDestination instanceof Date && toOrDestination instanceof Date && destination != undefined
    ) {
        //宿泊旅行を予約
    } else if (
        fromOrDestination instanceof Date && typeof toOrDestination === 'string'
    ) {
        //日帰り旅行を予約
    } else if (
        typeof fromOrDestination === 'string'
    ) {
        //すぐに出発する旅行を予約する
    } else {
        //エラー
    }
}

//call の実装を2番目の引数が string である関数についてだけ機能するように

function call<T extends [unknown, string, ...unknown[]], R>(
    f: (...args: T) => R,
    ...args: T
): R {
    return f(...args)
}

function fill(length: number, value: string): string[] {
    return Array.from({ length }, () => value)
}

let a = call(fill, 10, 'a')

