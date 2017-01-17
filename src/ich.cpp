#include <iostream>
#include <thread>
#include <algorithm>

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/json.hpp>
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>

#include "crow_all.h"
#include "json.h"

using json = nlohmann::json;

// MAIN
int main(int argc, char* argv[])
{
	// instantiate crow simple server app
	crow::SimpleApp app;

	// connect to mongodb
    mongocxx::instance inst{};
    mongocxx::client mongo{mongocxx::uri{"mongodb://127.0.0.1:27017"}};

	// ROUTES
    CROW_ROUTE(app, "/")(
	[&mongo](const crow::request& req)
	{
		// load body json
		auto x = json::parse(req.body);
        if(!x)
		{
			return crow::response(400, "No body specified!");
		}

		auto col = conn["ich"]["spacetime"];

		bsoncxx::builder::stream::document document{};
	    document << "hello" << "world";

	    col.insert_one(document.view());

        return "Hello world";
    });

	// determine the number of cores, or at least 1
	unsigned int cores = std::max(1, (int) std::thread::hardware_concurrency());
	std::cout << "Run on " << std::to_string(cores) << " cores." std::endl;

	// start server
    app.port(18080).concurrency(cores).multithreaded().run();
}
