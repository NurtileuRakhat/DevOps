#!/bin/bash
SERVICE_NAME="myapi.service"
sudo useradd -r -s /usr/sbin/nologin myapiuser

sudo mkdir -p /opt/myapi
sudo cp /home/aral/IdeaProjects/devopsForApiTesting/target/devopsForApiTesting-0.0.1-SNAPSHOT.jar /opt/myapi/
sudo chown -R myapiuser:myapiuser /opt/myapi
sudo chmod -R 700 /opt/myapi

sudo mkdir -R /home/logs
sudo chown -R myapiuser:myapiuser /home/logs
sudo chmod -R 700 /home/logs

sudo tee /etc/systemd/system/$SERVICE_NAME > /dev/null << EOF
[Unit]
Description=My Java API Service
After=network.target

[Service]
User=myapiuser
Group=myapiuser
WorkingDirectory=/opt/myapi
ExecStart=/usr/bin/java -jar /opt/myapi/devopsForApiTesting-0.0.1-SNAPSHOT.jar
SuccessExitStatus=143
Restart=on-failure
RestartSec=10s
Environment=JAVA_OPTS=-Xmx256m
StandardOutput=file:/home/logs/app.log
StandardError=file:/home/logs/app-error.log

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable $SERVICE_NAME

sudo systemctl start $SERVICE_NAME

sudo systemctl status $SERVICE_NAME --no-pager
