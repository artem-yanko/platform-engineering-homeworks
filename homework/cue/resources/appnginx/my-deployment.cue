package appnginx

import "github.com/ctrlops-io/cuehomework/homework/cue/schema"

deployment: schema.#KubernetesDeployment & {
    metadata: {
        name: "nginx-deployment"
    }
    spec: {
        replicas: 3
        selector: matchLabels: {
            app: "nginx"
        }
        template: {
            metadata: labels: {
                app: "nginx"
            }
            spec: containers: [{
                name:  "nginx"
                image: "nginx:1.14.2"
                ports: [{
                    containerPort: 80
                }]
                resources: {
                    limits: {
                        cpu: "1000m"
                        memory: "512Mi"
                    }
                    requests: {
                        cpu: "2"
                        memory: "1Gi"
                    }
                }
            }]
        }
    }
}