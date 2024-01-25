FROM confluentinc/cp-kafka-connect:7.5.0
USER root

RUN confluent-hub install --no-prompt confluentinc/connect-transforms:1.4.4 && \
	confluent-hub install --no-prompt confluentinc/kafka-connect-aws-dynamodb:1.3.3

# copy jmx prometheus exporter
RUN mkdir -p /opt/prometheus
COPY kafka-connect.tmp.yml /opt/prometheus/kafka-connect.yml
COPY jmx_prometheus_javaagent.jar /opt/prometheus/jmx_prometheus_javaagent.jar
RUN chown -R appuser:root /opt/prometheus