import {EventEmitter} from 'events'
import { threadId } from "worker_threads"

onmessage = e => {
    console.log(e.data)     // 'some data' とログに出力されます
    postMessage('Ack: "${e.data}"')
}

type Command =
    | { type: 'sendMessageToThred', data: [ThreadID, Message] }
    | { type: 'createThread', data: [Participants] }
    | { type: 'addUserThread', data: [ThreadID, UserID] }
    | { type: 'removeUserFromThread', data: [ThreadID, UserID] }

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

onmessage = ({ data }) => postMessage(handle(data))

declare function determinant(matrix: Matrix): number
declare function dotProduct(matrixA: Matrix, matrixB: Matrix): Matrix
declare function invert(matrix: Matrix): Matrix

onmessage = e => 
    processCommandFromMainThread(e.data)

function processCommandFromMainThread(
    command: Command
) {
    switch (command.type) {
        case 'sendMessageToThred':
            let [threadId, message] = command.data
            console.log(message)
    }
}

