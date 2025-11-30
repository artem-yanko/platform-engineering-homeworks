package resources

import ( "github.com/ctrlops-io/cuehomework/homework/cue/schema" )

#App: {
	#Name:   string
	#Image:   string
	#Replicas: int | *1
	#Port: int | *80
	#CpuLimits: string | *"1000m"
	#MemoryLimits: string | *"512Mi"
	#CpuRequests: string | *"500m"
	#MemoryRequests: string | *"256Mi"


	deployment: schema.#KubernetesDeployment & {
		metadata: {
			name: "\(#Name)-deployment"
		}
		spec: {
			replicas: #Replicas
			selector: matchLabels: {
				app: #Name
			}
			template: {
				metadata: labels: {
					app: #Name
				}
				spec: containers: [{
					name:  #Name
					image: #Image
					ports: [{
						containerPort: #Port
					}]
					resources: {
						limits: {
							cpu: #CpuLimits
							memory: #MemoryLimits
						}
						requests: {
							cpu: #CpuRequests
							memory: #MemoryRequests
						}
					}
				}]
			}
		}
	}

	service: schema.#KubernetesService & {
		metadata: {
			name: "\(#Name)-svc"
			labels: {
				app: #Name
			}
		}
		spec: {
			type: string | *"NodePort"
			selector: {
				app: #Name
			}
			ports: [{
				port: #Port
				targetport: #Port
			}]
		}
	}

	configMap: schema.#KubernetesConfigMap & {
		metadata: {
			name: "\(#Name)-cm"
			labels: {
				app: #Name
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
			    <p>Hello from \(#Name)!<p>
			</body>
			</html>
			"""
		}
	}
}
