#include <iostream>
#include <thread>
#include <algorithm>

#include "crow_all.h";

// MAIN
int main(int argc, char *argv)
{
	crow::SimpleApp app;

	// ROUTES
    CROW_ROUTE(app, "/")([](){
        return "Hello world";
    });

	// determine the number of cores, or at least 1
	unsigned int cores = std::max(1, std::thread::hardware_concurrency());

	// start server
    app.port(18080).concurrency(cores).multithreaded().run();
}
