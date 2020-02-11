# iOS + node.js使用Socket.IO框架进行实时通信示例

>本篇文章主要介绍了iOS + node.js使用Socket.IO框架进行实时通信示例，具有一定的参考价值，感兴趣的小伙伴们可以参考一下。


Socket.IO是一个基于WebSocket的实时通信库，在主流平台都有很好的支持，此文主要是通过一个小例子来演示Socket.IO的使用。

##基础环境搭建

新建一个文件夹（JS工程），创建一个package.json，复制以下内容并保存。

```
{
 "name": "socket-chat-example",
 "version": "0.0.1",
 "description": "my first socket.io app",
 "dependencies": {}
}
```

然后执行npm命令，安装我们需要的依赖（Express和Socket.IO）， 请确保你电脑已经有node环境

在项目根目录也就是package.json所在的目录在终端执行以下命令:

```
npm install --save express@4.10.2
 
npm install --save socket.io
```
进度条读完后会多这么一个文件夹，此时Express和Socket.IO就已经安装好了，这和iOS的Cocopods差不多，以模块化进行加载。

![](https://files.jb51.net/file_images/article/201704/201704140959573.png?201731410052)

然后新建一个index.js作为服务端，再建一个index.html作为客户端。（为了方便演示，我这里有两个客户端，一个是iOS端，一个是浏览器端）

## index.html
这也是官方Demo的演示界面，UI上没做修改

```
<!doctype html>
<html>
 <head>
  <title>Socket.IO chat</title>
  <style>
   * { margin: 0; padding: 0; box-sizing: border-box; }
   body { font: 13px Helvetica, Arial; }
   form { background: #000; padding: 3px; position: fixed; bottom: 0; width: 100%; }
   form input { border: 0; padding: 10px; width: 90%; margin-right: .5%; }
   form button { width: 9%; background: rgb(130, 224, 255); border: none; padding: 10px; }
   #messages { list-style-type: none; margin: 0; padding: 0; }
   #messages li { padding: 5px 10px; }
   #messages li:nth-child(odd) { background: #eee; }
  </style>
 </head>
 <body>
  <ul id="messages"></ul>
  <form action="">
   <input id="m" autocomplete="off" /><button>Send</button>
  </form>
 </body>
</html>
```
## index.js
```
var app = require('express')();
var http = require('http').Server(app);
var io  = require('socket.io')(http);
 
app.get('/',function(req,res){
  res.sendfile(__dirname + '/index.html');
});
http.listen(3000,function () {
  console.log('listien 3000');
});
```

开启了一个Server，监听3000端口，然后回到项目根目录，在终端输入`node index.js`

如果出现 listen 3000 则表明服务开启成功了，此时在浏览器访问 `http://localhost:3000 ` 就能看到index.html页面了


## iOS客户端的集成
新建一个iOS工程，在终端cd到项目根目录创建一个Podfile文件

```
use_frameworks!
 
target 'SocketIO_Chat_Example' do #项目名
  pod 'Socket.IO-Client-Swift', '~> 8.2.0'
end
```

保存退出，执行命令安装依赖

`pod install` or `pod install --verbose --no-repo-update`


## 使用Socket.IO
此时我们的客户端和服务端都已经有了Socket.IO的环境了，接下来就是使用它进行聊天了。

Socket.IO中事件的处理主要通过这两个方法来实现的

```
on(_ event: String, callback: NormalCallback)
 
emit(_ event: String, _ items: AnyObject...)
```
on方法为接收事件的方法，emit为发送事件的方法
我们的需求是让浏览器和iOS客户端进行单聊

## 服务端的处理

要想发送到指定的客户端，需要知道当前客户端的id（Socket.IO的id，例：3t60BArlK47a2fA-AAAd），但是客户端并不清楚，客户端只知道我们自己定义的id,所以我们要将Socket.IO的Id和我们自己定义的id绑定并存储起来。

```
var socketArray = new Array();
 
io.on('connection', function(socket){
  var islogin = false;
  console.log('**********新加入了一个用户*********',socket.id);
  socket.on('login',function (userId) {
    if(islogin) return;
    socket.userId = userId;
    socketArray.push(socket);
    islogin = true;
 
  });
  socket.on('privateMessage',function (data) {
    console.log(data);
  })
  socket.on('chat message', function(data){
    var to  = data.toUser;
    var message = data.message;
    for(var i = 0;i<socketArray.length;i++){
      var receiveData = socketArray[i];
      if (receiveData.userId == to){
        io.to([receiveData.socketId]).emit('privateMessage',''+receiveData.userId+'：'+message);
      }
    }
  });
  socket.on('disconnect',function () {
    console.log('***********用户退出登陆************,'+socket.id);
  })
});
```

## 客户端的处理

### 浏览器的处理

```
<script src="/socket.io/socket.io.js"></script>
<script src="http://code.jquery.com/jquery-1.11.1.js"></script>
<script>
  var socket = io();
  socket.emit('login','30621');
  $('form').submit(function(){
    socket.emit('chat message',{'toUser':'30342','message':$('#m').val()} );
    $('#m').val('');
    return false;
  });
  socket.on('chat message', function(msg){
    $('#messages').append($('<li>').text(msg));
  });
  socket.on('privateMessage',function (msg) {
    $('#messages').append($('<li>').text(msg));
  });
</script>
```


### iOS端的处理

iOS在初始化的时候需要一个config字典，config可以配置诸如log日志输出等设置

```
- (SocketIOClient *)client{
  if (!_client) {
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:3000"];
    _client = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
 
  }
  return _client;
}
 
- (void)connection{
 
  [self.client on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
    NSLog(@"*************\n\niOS客户端上线\n\n*************");
    [self.client emit:@"login" with:@[@"30342"]];
  }];
  [self.client on:@"chat message" callback:^(NSArray * _Nonnull event, SocketAckEmitter * _Nonnull ack) {
    if (event[0] && ![event[0] isEqualToString:@""]) {
      [self.messageArray insertObject:event[0] atIndex:0];
      [self.messageTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
  }];
  [self.client on:@"privateMessage" callback:^(NSArray * _Nonnull event, SocketAckEmitter * _Nonnull ack) {
    if (event[0] && ![event[0] isEqualToString:@""]) {
      [self.messageArray insertObject:event[0] atIndex:0];
      [self.messageTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
  }];
  [self.client on:@"disconnect" callback:^(NSArray * _Nonnull event, SocketAckEmitter * _Nonnull ack) {
    NSLog(@"*************\n\niOS客户端下线\n\n*************%@",event?event[0]:@"");
  }];
  [self.client on:@"error" callback:^(NSArray * _Nonnull event, SocketAckEmitter * _Nonnull ack) {
    NSLog(@"*************\n\n%@\n\n*************",event?event[0]:@"");
  }];
  [self.client connect];
 
}
//按钮点击事件
- (IBAction)sendMessage:(id)sender {
  if (self.inputView.text.length>0) {
 
    [self.client emit:@"chat message" with:@[@{@"toUser":@"30621",@"message":self.inputView.text}]];
    [self.messageArray insertObject:self.inputView.text atIndex:0];
    [self.messageTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    self.inputView.text = @"";
  }
 
}
```


# iOS 中的调试修改
开源第三方的矿框架，包括：CocoaAsyncSocket：https://github.com/robbiehanson/CocoaAsyncSocket，
Facebook出品的SocketRocket https://github.com/facebook/SocketRocket，
以及今天要说道的socket.io https://github.com/socketio/socket.io-client-swift。
这三个可以实现长连接的框架，都很厉害，但是因为我们的服务端是用socket.io实现的，所以我们客户端使用socket.io相关的也就最容易实现。
最新的是Socket.IO-Client-Swift，一个swift实现的Socket.IO框架，我们如果使用cocopods的话，直接
> pod 'Socket.IO-Client-Swift'

安装好之后，实现长连接就比较简单了：
1）首先在你的viewController中引入这个第三方，

```
@import SocketIO;
```
注意是@而不是#import，至于为何这样写请自行百度，这里就不赘述了。
2）引入好了框架，就开始连接

```
NSURL *url = [NSURL URLWithString:@"https://socketio-chat.now.sh/"];

//使用给定的url初始化一个socketIOClient，后面的config是对这个socket的一些配置，比如log设置为YES，控制台会打印连接时的日志等
SocketIOClient *socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];

    //监听是否连接上服务器，正确连接走后面的回调
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        [socket emit:@"kline_day" with:@[@"430009"]];
    }];
    //监听new message，这是socketIO官网提供的一个测试用例，大家都可以试试。如果成功连接，会收到data内容。
    [socket on:@"new message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"response is %@",data);
    }];
    [socket connect];
```

一般我们真正开发中，需要给服务端传递规定好的关键字，服务端才会正确的返回你想获取的数据，这个时候就要用到emmit（）方法：

>[socket emit:@"kline_day" with:@[@"430009"]];


上面的意思就是请求服务器430009这个股票代码的日k数据，一般我们将这个请求放在监听连接成功的方法中。
如果想停止本次长连接，也很简单，只需要用上面创建的socket对象调用disconnect（）方法即可。

> [self.socket disconnect];

这样一个长连接就成功了，之后就是解析获取到的数据，这个数据是每隔一定时间服务器自动推送的，我们是需要把这些数据展示在页面上即可。
