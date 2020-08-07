import { networkInterfaces } from "os";
import { stringify } from "querystring";
import { listenerCount } from "process";

namespace Network {
    //export function get<T>(url: string): Promise<T> {
    //    return  //
    //}
    export namespace HTTP {
        export function get<T>(url: string): Promise<T> {
            return //
        }
    }
    export namespace TCP {
        listenOn(port: number): Connection {
            return //
        }
    }
    export namespace UDP {
        //
    }
    export namespace IP {
        //
    }
}