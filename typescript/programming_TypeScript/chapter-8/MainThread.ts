let worker = new Worker('WokerScript.js')

worker.onmessage = e => {
    console.log(e.data)     // 'Ack: "some data"' とログに出力します
}

worker.postMessage('some data')

type Message = string
type ThreadID = number
type UserID = number
type Participants = UserID[]

type Comannds = {
    sendMessageToThread: [ThreadID, Message]
    createThread: [Participants]
    addUserToThread: [ThreadID, UserID]
    removeUserFromThread: [ThreadID, UserID]
}

type Events = {
    recivedMessage: [ThreadID, UserID, Message]
    createThread: [ThreadID, Participants]
    addUserToThread: [ThreadID, UserID]
}

type Protcol = {
    [command: string]: {
        in: unknown[]
        out: unknown
    }
}
function createProtocol<P extends Protocol>(script: string) {
    return <K extends keyof P>(command: K) => (...args: P[K]['in']) =>
        new Promise<P[K]['out']>((resolve, reject) => {
            let worker = new Worker(script)
            worker.onmessage = event => resolve(event.data)
            worker.postMessage({command, args})
        })
}

let runWithMatrixProtocol = createProtocol<MatrixProtocol>(
    'MatrixWorkerScript.js'
)
let parallelDeterminant = runWithMatrixProtocol('determinant')

parallelDeterminant([[1, 2], [3, 4]]).then(
    determinant => console.log(determinant)     // -2
)