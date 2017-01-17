var restify = require("restify");
var MongoClient = require("mongodb").MongoClient;

// create server
var server = restify.createServer({
  name: "Ich",
});
server.use(restify.bodyParser());

// ROUTES
server.post("/", function create(req, res, next) {

	// insert data into mongodb
	console.log(req.body);
	global.spacetime.insertMany(req.body);

	res.setHeader("Access-Control-Allow-Origin", "*");
	res.send(200, {
		"ack": true,
		"err": null
	});
	return next();
});

// open mongodb connection
MongoClient.connect("mongodb://localhost:27017/ich", function(err, db) {
	console.log("Connected correctly to mongodb server");

	// collections
	global.spacetime = db.collection("spacetime");

	// start restify server
	server.listen(18080);
});
