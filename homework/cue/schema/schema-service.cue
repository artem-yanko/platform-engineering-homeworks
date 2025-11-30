package schema

#KubernetesService: {
    apiVersion: "v1"
    kind:       "Service"
    metadata: {
        name:      string
        namespace: string | *"default"
        labels: {
            app: string
        }
    }
    spec: {
        type: string | *"NodePort"
        selector: {
            app: string
        }
        ports: [{
            port: int & >=1 & <=65535
            targetport: int & >=1 & <=65535
        }]
    }
}