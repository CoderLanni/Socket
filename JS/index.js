var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var path = require('path');
app.get('/', function(req, res){
  res.sendFile(path.join(__dirname,'index.html'));
});
 
io.on('connection', function(socket){
  console.log('a user connected');
  socket.on('disconnect', function(){
    console.log('user disconnected');
  });
  socket.on('chat message', function(msg){
    io.emit('chat message', msg);
    console.log('msg' + JSON.stringify(msg));
    console.log('message: ' + msg.message);
  });
});
 
http.listen(3000, function(){
  console.log('listening on *:3000');
});