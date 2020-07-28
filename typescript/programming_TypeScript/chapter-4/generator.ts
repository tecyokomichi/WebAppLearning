function* createFibonacciGenerator() {
    let a = 0
    let b = 1
    while (true) {
        yield a;
        [a, b] = [b, a + b]
    }
}

let finabonacciGenerator = createFibonacciGenerator()
finabonacciGenerator.next()
finabonacciGenerator.next()
finabonacciGenerator.next()
finabonacciGenerator.next()
finabonacciGenerator.next()

function* createNumbers(): Generator<number> {
    let n = 0
    while (1) {
        yield n++
    }
}

let numbers = createNumbers()
numbers.next()
numbers.next()
numbers.next()
numbers.next()
numbers.next()