const http = require('http'); // httpサーバーmodule
const hostname = 'localhost'; // ホスト名
const port = 3000; // port番号

var connection = require('./mysqlconnection');

connection.connect();

// httpサーバーの定義
const server = http.createServer((req, res) => {
  // 全リクエストを処理
  res.statusCode = 200; // http ステータスコード
  res.setHeader('Content-Type', 'text/html; charset=UTF-8');

  // 全ページ共通HTMLヘッド
  res.write('<html><head><title>掲示板</title><style>* {box-sizing:border-box;}</style></head><body style="position:relative;height:100%;">');
  res.write('<header style="border:1px solid #888;padding:40px;">掲示板</header>');
  res.write('<nav><ul><li><a href="/">トップ</a></li><li><a href="/authorindex">作者一覧</a></li></nav>');

  // ルーティング (url により振り分ける）
  switch (req.url) { // req.url にリクエストされたパスが入る
    case '/':
      res.write('<h1>トップページです</h1>\n');
      break;
    case '/authorindex':
      res.write('<h1>作者一覧</h1>\n');
      res.write('<tr id="header"><tr><td>id</td><td>名称</td><td>年齢</td><td> </td><td> </td><td> </td></tr></tr>');
      break;
    default:
      res.write('<h1>ページが見つかりません</h1>\n');
      break;
  }
  // 全ページ共通HTMLフッター
  res.write('<footer style="position:absolute;bottom:0;width:100%;border:1px solid #888;text-align:center;padding:20px;">フッター</footer>\n'); // 共通のフッター
  res.end('</body></html>'); // res.endでもコンテンツを返せる
});


// サーバー起動
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});

