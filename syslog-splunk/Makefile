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
		-e "s#{{DOCKER_IMAGE_NAME}}#$(DOCKER_IMAGE_NAME)#g" \
		-e "s#{{DOCKER_IMAGE_VERSION}}#$(DOCKER_IMAGE_VERSION)#g" \
		-e "s#{{SYSLOG_PORT}}#$(SYSLOG_PORT)#g" \
		-e "s#{{SPLUNK_HEC_TOKEN}}#$(SPLUNK_HEC_TOKEN)#g" \
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
SYSLOG_CONNECTOR_URL := $(CONNECTOR_URL)/syslog
SPLUNK_CONNECTOR_URL := $(CONNECTOR_URL)/splunk

connector-list:
	@curl -s $(CONNECTOR_URL) | jq

connector-deploy: syslog-deploy splunk-deploy

syslog-deploy:
	@mkdir -p tmp
	@sed -e "s#{{CONFLUENT_CLOUD_BOOTSTRAP}}#$(CONFLUENT_CLOUD_BOOTSTRAP)#g" \
		-e "s#{{CONFLUENT_CLOUD_SASL_JAAS_CONFIG}}#$(CONFLUENT_CLOUD_SASL_JAAS_CONFIG)#g" \
		-e "s#{{SYSLOG_PORT}}#$(SYSLOG_PORT)#g" \
		-e "s#{{SYSLOG_TOPIC}}#$(SYSLOG_TOPIC)#g" \
		connectors/syslog.json > tmp/syslog.json
	@curl -X PUT -s $(SYSLOG_CONNECTOR_URL)/config \
		--header 'Content-Type: application/json' \
		--data @tmp/syslog.json | jq

syslog-status:
	@curl -s $(SYSLOG_CONNECTOR_URL)/status | jq

syslog-send:
	bash bin/send-syslog.sh $(SYSLOG_HOST) $(SYSLOG_PORT)

syslog-undeploy:
	@curl -s -X DELETE $(SYSLOG_CONNECTOR_URL)

splunk-deploy:
	@mkdir -p tmp
	@sed -e "s#{{CONFLUENT_CLOUD_BOOTSTRAP}}#$(CONFLUENT_CLOUD_BOOTSTRAP)#g" \
		-e "s#{{CONFLUENT_CLOUD_SASL_JAAS_CONFIG}}#$(CONFLUENT_CLOUD_SASL_JAAS_CONFIG)#g" \
		-e "s#{{SPLUNK_HEC_URI}}#$(SPLUNK_HEC_URI)#g" \
		-e "s#{{SPLUNK_HEC_TOKEN}}#$(SPLUNK_HEC_TOKEN)#g" \
		-e "s#{{SPLUNK_HEC_SOURCE_TYPE}}#$(SPLUNK_HEC_SOURCE_TYPE)#g" \
		-e "s#{{SYSLOG_TOPIC}}#$(SYSLOG_TOPIC)#g" \
		connectors/splunk.json > tmp/splunk.json
	@curl -X PUT -s $(SPLUNK_CONNECTOR_URL)/config \
		--header 'Content-Type: application/json' \
		--data @tmp/splunk.json | jq

splunk-undeploy:
	@curl -s -X DELETE $(SPLUNK_CONNECTOR_URL)

splunk-status:
	@curl -s $(SPLUNK_CONNECTOR_URL)/status | jq
