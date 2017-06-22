
var app = require('express')();

/*var fs = require('fs');
var options = {
    key: fs.readFileSync('/etc/apache2/ssl/biopage.key'),
    cert: fs.readFileSync('/etc/apache2/ssl/biopage_com.crt')
};

var server = require('https').createServer(options, app);*/
var server = require('http').Server(app);
var io = require('socket.io')(server);
var redis = require('redis');

var online = [];

server.listen(10118);

var count = 0;

var redisClient = redis.createClient("http://10.28.83.120:6379/");

redisClient.subscribe('message');


io.on('connection', function (socket) {

    console.log("connected "+ socket.id );


    socket.on('setup', function (data) {
        if(typeof data != 'object'){
            data = JSON.parse(data);
        }
        console.log(data.user_id, data.socket_id, data.rooms);
        var error = false;
        var errorMessage = false;
        var socket_id = formatSocketID(data.socket_id);

        //////////// remove existing ///////////////////////
        for( var q=0; q < online.length; q++) {
            if (online[q].user_id == data.user_id) {
                online.splice(q, 1);
            }
        }
        ////////////// add new ///////////////////


        online.push({user_id : data.user_id , socket_id : socket_id});
        //console.log('setup');
        console.log(data.user_id + " uses "+ socket_id);

        try {
            /// join user all his rooms
            for( var q=0; q < data.rooms.length; q++) {
                console.log(data.user_id + ' joins ' +data.rooms[q]);
                socket.join(data.rooms[q]);
            }
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


    socket.on('newroom', function(data) {
        if(typeof data != 'object'){
            data = JSON.parse(data);
        }
        console.log(data);
        var error = false;
        var errorMessage = false;
        try {
            for( var q=0; q < data.participants.length; q++) {
                console.log(data.participants[q] + ' joins ' + data.room);
                var socket_id = getSocketID(data.participants[q]);
                if (socket_id) {
                    //socket_id = formatSocketID(formatSocketID);
                    io.sockets.connected[socket_id].join(data.room);
                    io.sockets.connected[socket_id].emit('newroom-created', {
                        "room": data.room
                    });
                }
            }
        }
        catch(err) {
            error = true;
            errorMessage = err.message;
            console.log(err.message);
        }
        finally {
            if (error) {
                socket.emit('newroom-status',{ success : 0, message: errorMessage });
            } else {
                socket.emit('newroom-status', { success : 1 });
            }
        }
        // console.log(io.sockets.connected[socket_id].rooms);

    });


    socket.on('leaveroom', function(data) {
        var error = false;
        var errorMessage = false;
        try {
            for( var q=0; q < data.participants.length; q++) {
                console.log(data.participants[q] + ' leaves ' + data.room);
                var socket_id = getSocketID(data.participants[q]);
                if (socket_id) {
                    console.log(socket_id);
                    io.sockets.connected[socket_id].leave(data.room);
                }
            }
        }
        catch(err) {
            error = true;
            errorMessage = err.message;
            console.log(err.message);
        }
        finally {
            if (error) {
                socket.emit('leaveroom-status',{ success : 0, message: errorMessage });
            } else {
                socket.emit('leaveroom-status', { success : 1 });
            }
        }
        // console.log(io.sockets.connected[socket_id].rooms);

    });


    socket.on('disconnect', function(reason) {

        console.log('disconnected - ' + reason);

        for( var q=0; q < online.length; q++) {
            if (online[q].socket_id == socket.id) {
                console.log('User : ' + online[q].user_id + ' = ' + socket.id);
                online.splice(q, 1);
            }
        }
        //   console.log(online);

    });

});

function formatSocketID(socket_id){
    if(socket_id.search("/#") == -1) {
        socket_id = "/#" + socket_id;
    }
    return socket_id;
}


function getSocketID(user_id){

    for( var q=0; q < online.length; q++) {

        if (online[q].user_id == user_id) {
            return online[q].socket_id;
        }
    }

    return false;
}


redisClient.on("message", function(channel, packet) {

    data = JSON.parse(packet);
    console.log(data);
    if(data.type == 'delete_message'){
        io.to(data['room']).emit('delete-message-event', {
            "room": data.room,
            "mid": data.mid,
            "sender_id": parseInt(data.sender_id),
        });
    }else{
        io.to(data['room']).emit('incoming-message', {
            "room": data.room,
            "message": data.message,
            "mid": data.mid,
            "sent_at": data.sent_at,
            "sent_date": data.sent_date,
            "sender_id": parseInt(data.sender_id),
            "name": data.name,
            "username": data.username,
            "profile_pic": data.profile_pic,
        });
    }

});

