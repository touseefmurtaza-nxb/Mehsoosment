// var app = require('express')();
// var http = require('http').Server(app);

// // app.get('/', function(req, res){
// //   res.send('<h1>Hello world</h1>');
// // });

// app.get('/', function(req, res){
// 	res.sendFile(__dirname + '/index.html');
// });


// http.listen(3000, function(){
//   console.log('listening on *:3000');
// });


var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var redis = require('redis');

var redisClient = redis.createClient("http://10.28.83.120:6379/");

redisClient.on("error", function (err) {
    console.log("Error " + err);
});

redisClient.subscribe('message');

redisClient.on('message', function(channel, message){
		console.log('redis receiver');
		
		data = JSON.parse(message);
		console.log(data.id);
    
    io.to(data.room).emit('incoming-message', {
            "room": data.room,
            "message": data.body,
            "sent_at": data.created_at,
            "sender_id": data.sender_id,
            "receiver_id": data.receiver_id
        });

});



io.on('connection', function (socket) {

    console.log("connected "+ socket.id );
    socket.on('setup', function (data) {
    	var error = false;
    	try { 
                console.log( ' joins ' + data );
                socket.join(data);
        }
        catch(err) {
            error = true;
            errorMessage = err.message;
            console.log(err.message);
        }
        finally {
            if (error) {
                socket.emit('setup-status', { success : 0, message: errorMessage });
            } else {
                socket.emit('setup-status', { success : 1 });
            }
        }
    });
});





// io.on('connection', function(socket){
//   console.log('a user connected');
//   socket.on('disconnect', function(){
//     console.log('user disconnected');
//   });
//   socket.on('chat message', function(msg){
//     console.log('message: ' + msg);
//     io.emit('chat message', msg);
//   });
// });


http.listen(10118, function(){
  console.log('listening on *:10118');
});
