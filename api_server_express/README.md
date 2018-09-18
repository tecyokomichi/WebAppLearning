## README

#### Express 導入
  
Express をインストールする環境  
```
yokomichi@Ubuntu16OnMacBook:~$ cat /etc/lsb-release 
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.5 LTS"
```
  
Express 導入  
```
npm install express-generator --save
```
`--save` オプションをつけてローカルにインストールします  
  
雛形作成  
```
express --view=ejs
```
  
必要な node モジュールのインストール  
```
npm install
```
  
起動確認  
```
DEBUG=node-test:* npm start
```
  
`localhost:3000` にアクセスしてみる  
