var http = require('http'),
  port = 80;

http.createServer(function (req, res) {
	switch(req.url) {
		case '/balancing/timeout':
			req.on('end', function() {
				setTimeout( function() {
					console.log('Response to client');
					res.statusCode = 204;
					res.end();
				} , 70 * 1000 );
			});
			break;
		case '/balancing':
			req.on('end', function() {
				console.log('Request headers: ');
				for(var h in req.headers) {
					console.log('	'+h+': '+req.headers[h]);
				}
				res.statusCode = 204;
				res.end();
			});
			break;
		case '/notification':
			req.on('data', function(d) {
				console.log('Received message from SNS: '+d);
			});
			req.on('end', function() {
				res.statusCode = 204;
				res.end();
			});
			break;
	}
}).listen(port);
console.log('Web server runs on port '+port);
