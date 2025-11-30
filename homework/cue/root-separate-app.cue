package homework

import ( "github.com/ctrlops-io/cuehomework/homework/cue/schema" )


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
                image: "nginx:1.14.2" // nginx:1.14.2
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

service: schema.#KubernetesService & {
    metadata: {
        name: "nginx-svc"
        labels: {
            app: "nginx"
        }
    }
    spec: {
        type: string | *"NodePort"
        selector: {
            app: "nginx"
        }
        ports: [{
            port: 80
            targetport: 80
        }]
    }
}

configMap: schema.#KubernetesConfigMap & {
    metadata: {
        name: "nginx-cm"
        labels: {
            app: "nginx"
        }
    }
    data: {
        "index.html": """
<!DOCTYPE html>
<html lang="en">
<head>
    <title>A simple HTML document</title>
</head>
<body>
    <p>Hello world!<p>
</body>
</html>
"""
    }
}
