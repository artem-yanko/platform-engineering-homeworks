package appnginx

import "github.com/ctrlops-io/cuehomework/homework/cue/schema"

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
        ports: {
            port: 80
            targetport: 80
        }
    }
}