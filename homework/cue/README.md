# CUE Lang Homework
## Structure
```
.
├── cue.mod
│   └── module.cue
├── README.md
├── resources
│   ├── appnginx
│   │   ├── my-config-map.cue
│   │   ├── my-deployment.cue
│   │   └── my-service.cue
│   ├── person
│   │   └── my-person.cue
│   └── templates.cue
├── root-separate-app.cue
├── root-tempated.cue
└── schema
    ├── schema-config-map.cue
    ├── schema-deployment.cue
    ├── schema-person.cue
    └── schema-service.cue
```

## Solution

### 1. Combine multiple Kubernetes resources (Deployment, Service, ConfigMap) in a single CUE configuration with proper validation + create a CUE module that can be imported and reused

I've created a module [`cue.mod`](cue.mod/module.cue) to make all schemas from `./schema` reusable. As result it can be imported into resources.
```
import ( "github.com/ctrlops-io/cuehomework/homework/cue/schema" )
```

**Resources** like deployment, config map and service can be found in directory [`./resources/appnginx/`](./resources/appnginx/)
and generated with `cue export root-separate-app.cue --out yaml` command

**Template** for templated approach can be found in [`./resources/templates.cue`](./resources/templates.cue) and generated with `cue export root-templated.cue --out yaml` command

---

### 2. Create custom validation rules and add comprehensive error messages for validation failures for your Kubernetes resources, such as:
    - Enforcing resource naming conventions
    - Validating image tags
    - Checking for required labels
    - Setting resource limits and requests

Custom validation rules added to **schemas**. Same as a comprehensive error messages.
Examples in [`schema-deployment.cue`](./schema/schema-deployment.cue) and [`schema-service.cue`](./schema/schema-service.cue) and listed down below

**Enforcing resource naming conventions**
```
...
#Name: (string & =~"^[a-z0-9]([-a-z0-9]*[a-z0-9])?$") | error("Resource name must be lowercase and alphanumeric.")

#KubernetesDeployment: {
    apiVersion: "apps/v1"
    kind:       "Deployment"
    metadata: {
        name: #Name
        namespace: string | *"default"
    }
...
```
```
cue export root-tempated.cue --out yaml
nginxAppDev.deployment.metadata.name: Resource name must be lowercase and alphanumeric.:
    ./schema/schema-deployment.cue:4:57
    ./resources/templates.cue:18:10
    ./schema/schema-deployment.cue:4:18
    ./schema/schema-deployment.cue:10:15
```

**Validating image tags**
```
#Image: (string & !~ ".*latest$") | error("Image tag 'latest' is not allowed. Please use a versioned tag.")// Validating image tags. "latest" tag is not allowed.

#KubernetesDeployment: {    }
    spec: {        }
        template: {            }
            spec: containers: [...{
                name:  #Name
                image: #Image
```
```
cue export root-tempated.cue --out yaml
nginxAppDev.deployment.spec.template.spec.containers.0.image: Image tag 'latest' is not allowed. Please use a versioned tag.:
    ./schema/schema-deployment.cue:3:37
    ./resources/templates.cue:31:13
    ./root-tempated.cue:8:10
    ./schema/schema-deployment.cue:3:19
    ./schema/schema-deployment.cue:24:24
```
**Checking for required labels**
```
#KubernetesDeployment: {
    ...
    metadata: {    }
    spec: {
        replicas: int & >=1 & <=10
        selector: matchLabels: {
            app!: #Name & != "" // Ensuring app label is present, not empty and match Name pattern
        }
    ...
```
**Setting resource limits and requests**
```
#KubernetesDeployment: {    }
    spec: {        }
        template: {            }
            spec: containers: [...{
                resources!: { // Resource requests and limits check
                    limits: {
                        cpu:    string & =~"^([0-9]+m|[0-9]+)$"              // Example: 500m or 1
                        memory: string & =~"^[0-9]+(Ki|Mi|Gi|Ti|Pi|Ei)?$"   // Example: 128Mi, 1Gi, 1024
                    }
                    requests: {
                        cpu:    string & =~"^([0-9]+m|[0-9]+)$"
                        memory: string & =~"^[0-9]+(Ki|Mi|Gi|Ti|Pi|Ei)?$"
                    }
                }
```
