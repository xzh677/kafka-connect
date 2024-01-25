# Introduction

A DynamoDB sink connector POC



# Usage

1. Create a `.env` file under project root based on `.env.template`

2. Run Kafka Connect locally
```
make run
```
- Create DockerImage
- Create docker compose yaml under `tmp`
- Run docker compose

3. Create topic on Kafka

4. Deploy the connector
```
make dynamodb-deploy
```

# Notes
Consider to modify the environment variable in `docker-compose.tpl.yml` to control the poll frequency of the sink connector
```shell
CONNECT_OFFSET_FLUSH_INTERVAL_MS=2000
```
