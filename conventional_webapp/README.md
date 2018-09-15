## README
  
https://github.com/tecowl/techno-people/issues/109 の作業を生のnodejsを使って実現します  

### nodejs のインストール
  
Node.js をインストールする環境
```
yokomichi@Ubuntu16OnMacBook:~$ cat /etc/lsb-release 
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.5 LTS"

```
  
まずは以下コマンドで `nodejs` と `npm` をインストール  
```
$ sudo apt install nodejs npm  
```
os の状態によっては  
```
Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?  
```
となってインストールできないことがあるので、この場合  
```
$ sudo apt update
```
して  
```
$ apt list ―upgradable
```
続いて  
```
$ sudo apt upgrade
```
してから再度  
```
$ sudo apt install nodejs npm
```
#### 最新版を入れる場合
```
$ sudo n latest
```
#### 安定板を入れる場合
```
$ sudo n stable
```
バージョン確認  
```
yokomichi@Ubuntu16OnMacBook:~$ node -v
v10.8.0
yokomichi@Ubuntu16OnMacBook:~$ npm -v
6.2.0
yokomichi@Ubuntu16OnMacBook:~$ n --version
2.1.12
```
  
apt でインストールした nodejs と npm のアンインストール  
```
$ sudo apt purge nodejs npm
```
```
$ sudo apt autoremove
```
  
### node-dev
プログラムの変更を反映させるためにサーバを都度再起動するのは面倒なので `node-dev` をインストールします  
#### インストール
```
$ sudo npm install -g node-dev
```
ここでは `-save` オプションをつけてローカルにインストールしてみました  
  
#### 使い方
```
node *****.js
```
で起動していたものを  
```
$ node-dev *****.js
```
で起動するようにすれば  
`*****.js` と関連するファイルを編集するたびに自動で再起動するようになります  
  
### mysql
データベースに MySQL を使うので MySQL 接続用のモジュールをインストールします
#### インストール
```
$ npm install mysql --save
```
ここでは `--save` オプションをつけてローカルにインストールしました  
package.json に追記されます 
  
### マイグレーション
マイグレーション用のモジュールをインストールします
#### インストール
```
$ npm install db-migrate --save
```
`--save` オプションをつけてるのでローカルにインストールされます  
  
`db-migrate` が DB を操作するのに必要なモジュールをインストールします  
#### インストール
```
$ npm install db-migrate-mysql --save
```
ここでも `--save` オプションをつけてローカルにインストールします  
  
### ejs
テンプレートエンジン `EJS` をインストールします  
#### インストール
```
$ npm install ejs --save
```
`--save` オプションをつけてローカルにインストールします  
package.json に追記されます  

### サーバ起動とアクセス
  
プロジェクトのルートディレクトリで  
```
$ node-dev main.js
```
とタイプしてサーバを起動します  
  
`http://localhost:3939` でトップ画面にアクセスできます  
