interface Currency {
    unit: 'EUR' | 'GBP' | 'JPY' | 'USD'
    value: number
}

namespace Currency {
    export let DEFAULT: Currency['unit'] = 'USD'
    export function from(value: number, unit = Currency.DEFAULT): Currency {
        return { unit, value }
    }
}

let amoutDue: Currency = {
    unit: 'JPY',
    value: 83733.1
}

let otherAmountDue = Currency.from(330, 'EUR')


enum Color {
    RED = '#FF0000',
    GREEN = '#00FF00',
    BLUE = '#0000FF'
}

namespace Color {
    export function getClosest(to: string): Color { 
        return //
    }
}