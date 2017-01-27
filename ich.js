var restify = require("restify");
var MongoClient = require("mongodb").MongoClient;
var moment = require("moment");

// create server
var server = restify.createServer({ name: "Ich" });
server.use(restify.bodyParser());

// POST /
server.post("/", function create(req, res, next) {

    // prepare time data
    var data = req.body.map(function(item) {
        item["time"] = new Date(item["time"]);
        return item;
    });

    // insert data into mongodb
    global.spacetime.insertMany(data);

    res.setHeader("Access-Control-Allow-Origin", "*");
    res.send(200, { ack: true, err: null });
    return next();
});

// GET /
server.get("/", function(req, res, next) {

    // find latest entry and return it
    global.spacetime.findOne({}, { "sort": { "time": -1 } }, function(err, data) {

        // handle error
        if (err) {
            res.send(500, err);
        }

		// return data
		else {
            res.send(200, data);
        }

        return next();
    });
});

server.get("/:from/:till", function(req, res, next) {

	console.log(req.params.from, req.params.till);

	var from = moment(parseFloat(req.params.from));
	var till = moment(parseFloat(req.params.till));

	// find latest entry and return it
    global.spacetime.find({
		"time" : {
		    "$gte" : from.toDate(),
		    "$lt" : till.toDate()
		}
	}, {
		"sort": {
			"time": -1
		}
	}).toArray(function(err, data) {

        // handle error
        if (err) {
            res.send(500, err);
        }

		// return data
		else {

			var features = data.map(function(item) {
				return {
					"type": "Feature",
					"properties": {},
					"geometry": item.loc
			    };
			});

			res.setHeader("Access-Control-Allow-Origin", "*");
            res.send(200, {
				"type": "FeatureCollection",
				"features": features
			});
        }

        return next();
    });
});

// open mongodb connection
MongoClient.connect("mongodb://localhost:27017/ich", function(err, db) {
    console.log("Connected correctly to mongodb server");

    // collections
    global.spacetime = db.collection("spacetime");

    // start restify server
    server.listen(18080);
});
