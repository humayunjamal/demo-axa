[{
  "dnsSearchDomains": null,
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "demo-service-uat",
      "awslogs-region": "eu-west-1",
      "awslogs-stream-prefix": "demo-service-uat"
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
  "environment": [],
  "ulimits": null,
  "dnsServers": null,
  "mountPoints": [],
  "workingDirectory": null,
  "dockerSecurityOptions": null,
  "memory": 2500,
  "memoryReservation": 512,
  "volumesFrom": [],
  "image": "418754825935.dkr.ecr.eu-west-1.amazonaws.com/demo-service-uat:latest",
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
  "name": "demo-service-uat"
}
]