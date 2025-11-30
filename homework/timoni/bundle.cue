bundle: {
    _cluster: {
        name:  string @timoni(runtime:string:TIMONI_CLUSTER_NAME)
        group: string @timoni(runtime:string:TIMONI_CLUSTER_GROUP)
        uid:   string @timoni(runtime:string:CLUSTER_UID)
    }

    apiVersion: "v1alpha1"
    name:       "apps"
    instances: {
        "web-demo-\(_cluster.group)": {
            module: {
                url: "file://my-web-app"
            }
            namespace: "default"
            values: {
                image: {
                    repository: "nginx"
                    digest:     ""
                    tag:        "latest"
                }
                ingress: {
                    enabled: true
                    host:    "web-demo-\(_cluster.group).local"
                }
                if _cluster.group == "staging" {
                    replicas: 1
                    env: [
                        {
                            name:  "ENV"
                            value: "\(_cluster.group)"
                        },
                    ]
                }
                if _cluster.group == "production" {
                    replicas: 3
                    ingress: {
                        enabled: true
                        host:    "web-demo-\(_cluster.group).local"
                        }
                    healthcheck: {
                    livenessProbe: {
                        httpGet: {
                            path: "/healthz"
                            port: "http"
                        }
                    }
                    readinessProbe: {
                        httpGet: {
                            path: "/healthz"
                            port: "http"
                            }
                        }
                    }
                    env: [
                        {
                            name:  "ENV"
                            value: "\(_cluster.group)"
                        },
                    ]
                }
            }
        }
    }
}
