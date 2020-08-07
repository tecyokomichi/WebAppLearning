type Data<
    P extends Protcol,
    C extends keyof P = keyof P
    > = C extends C
    ? { command: C;, args: P[C]['in'] }
    : never

function handle(
    data: Data<MatrixProtocol>
): MatrixProtocol[typeof data.command]['out'] {
    switch (data.command) {
        case 'determinant':
            return determinant(...data.args)
        case 'dot-product':
            return dotProduct(...data.args)
        case 'invert':
            return invert(...data.args)
    }
}

process.on('message', data => process.send!(handle(data)))