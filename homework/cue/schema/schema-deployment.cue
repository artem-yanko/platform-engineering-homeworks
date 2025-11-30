package schema

#Image: (string & !~ ".*latest$") | error("Image tag 'latest' is not allowed. Please use a versioned tag.")// Validating image tags. "latest" tag is not allowed.
#Name: (string & =~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?$") | error("Resource name must be lowercase and alphanumeric.")

#KubernetesDeployment: {
    apiVersion: "apps/v1"
    kind:       "Deployment"
    metadata: {
        name: #Name
        namespace: string | *"default"
    }
    spec: {
        replicas: int & >=1 & <=10
        selector: matchLabels: {
            app!: #Name & != "" // Ensuring app label is present, not empty and match Name pattern
        }
        template: {
            metadata: labels: {
                app: #Name & != ""
            }
            spec: containers: [...{
                name:  #Name
                image: #Image
                ports?: [...{
                    containerPort: int & >=1 & <=65535
                }]
                resources: { // Resource requests and limits check
                    limits: {
                        cpu:    string & =~"^([0-9]+m|[0-9]+)$"              // Example: 500m or 1
                        memory: string & =~"^[0-9]+(Ki|Mi|Gi|Ti|Pi|Ei)?$"   // Example: 128Mi, 1Gi, 1024
                    }
                    requests: {
                        cpu:    string & =~"^([0-9]+m|[0-9]+)$"
                        memory: string & =~"^[0-9]+(Ki|Mi|Gi|Ti|Pi|Ei)?$"
                    }
                }
            }]
        }
    }
}
