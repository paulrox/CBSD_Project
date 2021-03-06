CC = g++
CFLAGS = -Wall -std=c++11 -g -pedantic
LDFLAGS = -L/usr/local/lib -lzmq 

EXEC_1 = RSF_deployment_unit
SOURCES_1 = $(wildcard src/deployment_unit/*.cpp) 

PATH_1 = src/deployment_unit/
OBJECTS_1 = $(SOURCES_1:.cpp=.o)

EXEC_2 = RSF_server
SOURCES_2 = $(wildcard src/server/*.cpp) 
PATH_2 = src/server/
OBJECTS_2 = $(SOURCES_2:.cpp=.o)

EXEC_3 = RSF_broker
SOURCES_3 = $(wildcard src/broker/*.cpp)
PATH_3 = src/broker/
OBJECTS_3 = $(SOURCES_3:.cpp=.o)

EXEC_4 = RSF_client
SOURCES_4 = $(wildcard src/client/*.cpp) 
PATH_4 = src/client/
OBJECTS_4 = $(SOURCES_4:.cpp=.o)

EXEC_5 = RSF_start_server
SOURCES_5 = $(wildcard src/health_checker_server/*.cpp) 
PATH_5 = src/health_checker_server/
OBJECTS_5 = $(SOURCES_5:.cpp=.o)

EXEC_6 = RSF_start_broker
SOURCES_6 = $(wildcard src/health_checker_broker/*.cpp)
PATH_6 = src/health_checker_broker/
OBJECTS_6 = $(SOURCES_6:.cpp=.o)

SOURCES_U = $(wildcard src/utilities/*.cpp)
PATH_U = src/utilities/
OBJECTS_U = $(SOURCES_U:.cpp=.o)

SOURCES_F = $(wildcard src/framework/*.cpp)
PATH_F = src/framework/
OBJECTS_F = $(SOURCES_F:.cpp=.o)

all: $(EXEC_1) $(EXEC_2) $(EXEC_3) $(EXEC_4) $(EXEC_5) $(EXEC_6)

$(EXEC_1): $(OBJECTS_1) $(OBJECTS_U) $(OBJECTS_F)
	$(CC) $(OBJECTS_1) $(OBJECTS_U) $(OBJECTS_F) -o $(EXEC_1) $(LDFLAGS) 

$(EXEC_2): $(OBJECTS_2) $(OBJECTS_U) $(OBJECTS_F)
	$(CC) $(OBJECTS_2) $(OBJECTS_U) $(OBJECTS_F) -lpthread -o $(EXEC_2) $(LDFLAGS) 

$(EXEC_3): $(OBJECTS_3) $(OBJECTS_U) $(OBJECTS_F)
	$(CC) $(OBJECTS_3) $(OBJECTS_U) $(OBJECTS_F) -o $(EXEC_3) $(LDFLAGS) 

$(EXEC_4): $(OBJECTS_4) $(OBJECTS_U) $(OBJECTS_F)
	$(CC) $(OBJECTS_4) $(OBJECTS_U) $(OBJECTS_F) -o $(EXEC_4) $(LDFLAGS)

$(EXEC_5): $(OBJECTS_5) $(OBJECTS_U) $(OBJECTS_F)
	$(CC) $(OBJECTS_5) $(OBJECTS_U) $(OBJECTS_F) -o $(EXEC_5) $(LDFLAGS)

$(EXEC_6): $(OBJECTS_6) $(OBJECTS_U) $(OBJECTS_F)
	$(CC) $(OBJECTS_6) $(OBJECTS_U) $(OBJECTS_F) -o $(EXEC_6) $(LDFLAGS)
		
$(PATH_1)%.o: $(PATH_1)%.cpp 
	$(CC) -c $(CFLAGS) $< -o $@

$(PATH_2)%.o: $(PATH_2)%.cpp 
	$(CC) -c $(CFLAGS) $< -o $@

$(PATH_3)%.o: $(PATH_3)%.cpp
	$(CC) -c $(CFLAGS) $< -o $@

$(PATH_4)%.o: $(PATH_4)%.cpp 
	$(CC) -c $(CFLAGS) $< -o $@
	
$(PATH_5)%.o: $(PATH_5)%.cpp 
	$(CC) -c $(CFLAGS) $< -o $@

$(PATH_6)%.o: $(PATH_6)%.cpp 
	$(CC) -c $(CFLAGS) $< -o $@
	
$(PATH_U)%.o: $(PATH_U)%.cpp 
	$(CC) -c $(CFLAGS) $< -o $@

$(PATH_F)%.o: $(PATH_F)%.cpp 
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -rf $(EXEC_1) $(OBJECTS_1)
	rm -rf $(EXEC_2) $(OBJECTS_2)
	rm -rf $(EXEC_3) $(OBJECTS_3)
	rm -rf $(EXEC_4) $(OBJECTS_4)
	rm -rf $(EXEC_5) $(OBJECTS_5)
	rm -rf $(EXEC_6) $(OBJECTS_6)
	rm -rf $(OBJECTS_U)
	rm -rf $(OBJECTS_F)

clean_$(EXEC_1):
	rm -rf $(EXEC_1) $(OBJECTS_1) $(OBJECTS_U) $(OBJECTS_F)
	
clean_$(EXEC_2):
	rm -rf $(EXEC_3) $(OBJECTS_3) $(OBJECTS_U) $(OBJECTS_F)

clean_$(EXEC_3):
	rm -rf $(EXEC_3) $(OBJECTS_3) $(OBJECTS_U) $(OBJECTS_F)

clean_$(EXEC_4):
	rm -rf $(EXEC_4) $(OBJECTS_4) $(OBJECTS_U) $(OBJECTS_F)
	
clean_$(EXEC_5):
	rm -rf $(EXEC_5) $(OBJECTS_5) $(OBJECTS_U) $(OBJECTS_F)

clean_$(EXEC_6):
	rm -rf $(EXEC_6) $(OBJECTS_6)gi $(OBJECTS_U) $(OBJECTS_F)
