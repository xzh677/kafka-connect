include .env


clean:
	rm -rf tmp
	rm connect-docker/*.jar
	rm connect-docker/*.yml

config:
	@mkdir -p tmp
	@sed -e "s#{{CONFLUENT_CLOUD_BOOTSTRAP}}#$(CONFLUENT_CLOUD_BOOTSTRAP)#g" \
		-e "s#{{CONFLUENT_CLOUD_SASL_JAAS_CONFIG}}#$(CONFLUENT_CLOUD_SASL_JAAS_CONFIG)#g" \
		-e "s#{{GROUP_ID}}#$(GROUP_ID)#g" \
		-e "s#{{CONFIG_STORAGE_TOPIC}}#$(CONFIG_STORAGE_TOPIC)#g" \
		-e "s#{{OFFSET_STORAGE_TOPIC}}#$(OFFSET_STORAGE_TOPIC)#g" \
		-e "s#{{STATUS_STORAGE_TOPIC}}#$(STATUS_STORAGE_TOPIC)#g" \
		-e "s#{{AWS_ACCESS_KEY_ID}}#$(AWS_ACCESS_KEY_ID)#g" \
		-e "s#{{AWS_SECRET_ACCESS_KEY}}#$(AWS_SECRET_ACCESS_KEY)#g" \
		-e "s#{{DOCKER_IMAGE_NAME}}#$(DOCKER_IMAGE_NAME)#g" \
		-e "s#{{DOCKER_IMAGE_VERSION}}#$(DOCKER_IMAGE_VERSION)#g" \
		docker-compose.tpl.yml > tmp/docker-compose.yml

docker:
	@cd tmp && docker-compose up

docker-delete:
	@cd tmp && docker-compose down

build-docker:
	@cp jmx/kafka-connect.yml connect-docker/kafka-connect.tmp.yml
	@cp $(JMX_AGENT_PATH) connect-docker/jmx_prometheus_javaagent.jar
	@cd connect-docker && docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) .

run: build-docker config docker


CONNECTOR_URL := localhost:8083/connectors
DYNAMODB_CONNECTOR_URL := $(CONNECTOR_URL)/dynamodb

connector-list:
	@curl -s $(CONNECTOR_URL) | jq

connector-deploy: dynamodb-deploy

dynamodb-deploy:
	@mkdir -p tmp
	@sed -e "s#{{CONFLUENT_CLOUD_BOOTSTRAP}}#$(CONFLUENT_CLOUD_BOOTSTRAP)#g" \
		-e "s#{{CONFLUENT_CLOUD_SASL_JAAS_CONFIG}}#$(CONFLUENT_CLOUD_SASL_JAAS_CONFIG)#g" \
		-e "s#{{DYNAMODB_TOPICS}}#$(DYNAMODB_TOPICS)#g" \
		connectors/dynamodb-sink.json > tmp/dynamodb-sink.json
	@curl -X PUT -s $(DYNAMODB_CONNECTOR_URL)/config \
		--header 'Content-Type: application/json' \
		--data @tmp/dynamodb-sink.json | jq

dynamodb-status:
	@curl -s $(DYNAMODB_CONNECTOR_URL)/status | jq

dynamodb-undeploy:
	@curl -s -X DELETE $(DYNAMODB_CONNECTOR_URL)

