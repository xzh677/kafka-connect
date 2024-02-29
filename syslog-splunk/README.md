

1. Create a `.env` file under project root based on `.env.template`

2. Run Kafka Connect locally
```
make run
```
- Create DockerImage
- Create docker compose yaml under `tmp`
- Run docker compose

3. Create topic `syslog-source` on Kafka


4. Deploy connectors
```
make connector-deploy
```

5. Test sys log connector
```
bin/send-syslog.sh
```

6. Check data
http://localhost:8088