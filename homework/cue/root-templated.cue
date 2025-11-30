package homework

import ( "github.com/ctrlops-io/cuehomework/homework/cue/resources" )


nginxAppDev: resources.#App & {
	#Name: "nginx-dev"
	#Image: "nginx:1.14.2"
	#Replicas: 1
	#Port: 8080
	#CpuLimits: "500m"
	#MemoryLimits: "256Mi"
	#CpuRequests: "250m"
	#MemoryRequests: "128Mi"
}

nginxAppProd: resources.#App & {
	#Name: "nginx-prod"
	#Image: "nginx:1.14.2"
	#Replicas: 3
	#Port: 80
	#CpuLimits: "1000m"
	#MemoryLimits: "512Mi"
	#CpuRequests: "500m"
	#MemoryRequests: "256Mi"
}
