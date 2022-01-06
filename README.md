# Kafka-MongoDB-R

[![LinkedIn][linkedin-shield]][linkedin-url]

![](overview.png)

This small tutorial creates a data pipeline from Apache Kafka over MongoDB into R.
It focuses on simplicity and can be seen as a baseline for similar projects.
You can read more about in my blog article: 
[Create a Data Analysis Pipeline with Apache Kafka and RStudio](https://www.confluent.io/de-de/blog/data-analytics-pipeline-with-kafka-and-rstudio/).


## Prerequisites

* [docker](https://docs.docker.com/get-docker/)
* [docker-compose](https://docs.docker.com/compose/install/)
* [MongoDB Compass](https://www.mongodb.com/try/download/compass)

## Set up
```
docker-compose up -d
```

It starts:
* Zookeeper
* Kafka Broker 
* Kafka Producer
  * built docker image executing fat JAR
* Kafka Connect
    * with [MongoDB Connector](https://www.confluent.io/hub/mongodb/kafka-connect-mongodb)
* MongoDB 
* RStudio

## Kafka Producer

The Kafka Producer produces fake events of a driving truck into the topic `truck-topic` in `JSON` format every two seconds.
Verify that data is produced correctly:
```
docker-compose exec broker bash
kafka-console-consumer --bootstrap-server broker:9092 --topic truck-topic
```

![](KafkaProducer.gif)

## Kafka Connect

We use Kafka Connect to transfer the data from Kafka to MongoDB.
Verify that the MongoDB Source and Sink Connector is added to Kafka Connect correctly:
```
curl -s -XGET http://localhost:8083/connector-plugins | jq '.[].class'
```
Start the connector:
```
curl -X POST -H "Content-Type: application/json" --data @MongoDBConnector.json http://localhost:8083/connectors | jq
```
Verify that the connector is up and running:
```
curl localhost:8083/connectors/TestData/status | jq
```


## MongoDB 
Start MongoDB Compass and create a new connection with:
```
username: user
password: password
authentication database: admin
or
URI: mongodb://user:password@localhost:27017/admin
```
You should see a database `TruckData` with a collection `truck_1` having data stored.

![](MongoDB.gif)

## RStudio
Open RStudio via:
```
localhost:8787
```
The username is `user` and password `password`.

Under `/home` you can run `GetData.R`. It connects to MongoDB using the package [mongolite](https://cran.r-project.org/web/packages/mongolite/mongolite.pdf) and requests the data.

![](RStudio.gif)

## Sources

* [Confluent Docker-Compose file](https://github.com/confluentinc/cp-all-in-one/blob/6.1.1-post/cp-all-in-one/docker-compose.yml)
* [Confluent Docker Configuration Parameters](https://docs.confluent.io/platform/current/installation/docker/config-reference.html)
* [Confluent Kafka Connect](https://docs.confluent.io/home/connect/userguide.html#installing-kconnect-plugins)
* [Confluent Hub MongoDB Connector](https://www.confluent.io/hub/mongodb/kafka-connect-mongodb)
* [MongoDB Connector Configuration Properties](https://docs.mongodb.com/kafka-connector/current/kafka-sink-properties/)
* [mongolite Package](https://cran.r-project.org/web/packages/mongolite/mongolite.pdf)


[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/patrick-neff-7bb3b21a4/
