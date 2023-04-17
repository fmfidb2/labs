# Lab 8 - Redis

## Setup

Download & run Redis in a container using docker

````
docker run -p 6379:6379 redis
````

## Labs

Write two simple programs which will simulate an application (producer) submitting background jobs to a worker (consumer) via Redis.

### The producer

Implement a message producer application in your preferred programming language that connects to the Redis instance and pushes messages to a Redis list, simulating message production in a distributed environment.

### The consumer

Implement a message consumer application that connects to the Redis instance and pulls messages from the Redis list, simulating message consumption in a distributed environment. 

Experiment with different strategies for consuming messages, such as polling and blocking. Try to simulate failure & restart of the consumer. What happens with messages which were pulled from the queue but were not yet processed? Look for Redis commands which would allow for creation of a reliable queue.
