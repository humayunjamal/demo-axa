[{
  "dnsSearchDomains": null,
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "demo-service",
      "awslogs-region": "eu-west-1",
      "awslogs-stream-prefix": "demo-service"
    }
  },
  "entryPoint": null,
  "portMappings": [{
    "hostPort": 0,
    "protocol": "tcp",
    "containerPort": 80
  }],
  "command": null,
  "linuxParameters": null,
  "cpu": 0,
  "environment": [
       {
          "name": "ENVS_PATH",
          "value": "/staging/ops-exp/promotion/envs"
        }
  ],
  "ulimits": null,
  "dnsServers": null,
  "mountPoints": [],
  "workingDirectory": null,
  "dockerSecurityOptions": null,
  "memory": 2500,
  "memoryReservation": 512,
  "volumesFrom": [],
  "image": "083052042026.dkr.ecr.eu-west-1.amazonaws.com/general/promotion:latest",
  "disableNetworking": null,
  "healthCheck": null,
  "essential": true,
  "links": null,
  "hostname": null,
  "extraHosts": null,
  "user": null,
  "readonlyRootFilesystem": null,
  "dockerLabels": null,
  "privileged": null,
  "name": "demo-service"
}
]