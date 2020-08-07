import { networkInterfaces } from "os";

namespace App {
    Network.get<GitRepo>('https://api.github.com/repos/Microsoft/typescript')
}