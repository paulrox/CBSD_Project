/*
 *	broker_class.cpp
 *
 */
#include <string>
#include <iostream>
#include <unistd.h>
#include "../../include/broker_class.hpp"
#include "../../include/communication.hpp"
#include "../../include/util.hpp"

/**
 * @brief Broker constructor that initializes alle the private data and
 * 	  claims memory for ZPQ sockets. Then it connects to the socket.
 * @param nmr Redundancy for the voter
 * @param port_router It is the port for client communication
 * @param port_reg It is the port for the server registration
 * 
 */

Broker::Broker(uint8_t nmr, uint16_t port_router, uint16_t port_reg) 
{	
	int32_t opt;

	this->nmr = nmr;
	this->port_router = port_router;
	this->port_reg = port_reg;

	/* Allocating ZMQ context */
	try {
		context = new zmq::context_t(1);
	} catch (std::bad_alloc& ba) {
		std::cerr << "bad_alloc caught: " << ba.what() << std::endl;
		exit(EXIT_FAILURE);
	}

	/* Router socket creation */
	router = add_socket(context, ANY_ADDRESS, port_router, ZMQ_ROUTER, 
		BIND);
	/* This option is used to enable error messages when an invalid
	 * identity is used to send a message with a ROUTER socket
	 */
	opt = 1;
	router->setsockopt(ZMQ_ROUTER_MANDATORY, &opt, sizeof(int32_t));
	
	/* Registration socket creation */
	reg = add_socket(context, ANY_ADDRESS, port_reg, ZMQ_ROUTER, BIND);

	/* Dealer socket creation (TEST) */
	dealer.push_back(add_socket(context, ANY_ADDRESS, DEALER_START_PORT, ZMQ_DEALER, BIND));

	/* Initialize the poll set */
	zmq::pollitem_t tmp = {static_cast<void*>(*router), 0, ZMQ_POLLIN, 0};
	items.push_back(tmp);
	tmp = {static_cast<void*>(*reg), 0, ZMQ_POLLIN, 0};
	items.push_back(tmp);
	tmp = {static_cast<void*>(*dealer.front()), 0, ZMQ_POLLIN, 0};
	items.push_back(tmp);

}

/* Broker denstructor */

Broker::~Broker()
{
	delete context;
	delete router;
	delete reg;
}

void Broker::step()
{
	int32_t more;

	/* Temporary pointer to the first element in the dealer list */
	zmq::socket_t *dealer_test = dealer.front();

	for (;;) {
		zmq::message_t message;

		zmq::poll(items, -1);
		std::cout << "Waking up" << std::endl;
		/* Check for messages on the router socket */
		if (items[0].revents & ZMQ_POLLIN) {
			for(;;) {
				/* Receiving the value to elaborate */
				router->recv(&message);
				size_t more_size = sizeof (more);
				router->getsockopt(ZMQ_RCVMORE, &more, 
					&more_size);
				dealer_test->send(message, more? ZMQ_SNDMORE: 0);

				if (!more)
					break;
			}
		}
		/* Check for a registration request */
		if (items[1].revents & ZMQ_POLLIN) {

			for(;;) {
				/* Receiving the value to elaborate */
				std::cout << "Receiving registration" << std::endl;
	       			reg->recv(&message);
	       			size_t more_size = sizeof(more);
                		reg->getsockopt(ZMQ_RCVMORE, &more, 
                			&more_size);
				
				if (more == 1) 
					reg->send(message, ZMQ_SNDMORE);
	       	   		if (!more) {
	       	   			int32_t val = *(static_cast<int32_t*> 
	       	   				(message.data()));
	            			std::cout << "Received " 
	            				<< val << std::endl;
	       		
       					/* Elaborating */
       					val = val + 1;
	       	   			/* Sending back the result */
       					zmq::message_t reply(4);
       					memcpy(reply.data(), 
       						(void *) &val, 4);
	        			std::cout << "Sending "<< val 
	        				<< std::endl;
	       	   			reg->send(reply, 0);
	       	   			break;
	       	   		}
			}
		}
		/* Check for messages on the dealer socket */
		if (items[2].revents & ZMQ_POLLIN) {
			for(;;) {
				/* Receiving the value to elaborate */
				dealer_test->recv(&message);
				size_t more_size = sizeof (more);
				dealer_test->getsockopt(ZMQ_RCVMORE, &more, 
					&more_size);
				router->send(message, more? ZMQ_SNDMORE: 0);

				if (!more) 
					break;
			}
		}
	}
}