package schema

#KubernetesConfigMap: {
	apiVersion: "v1"
	kind:       "ConfigMap"

	metadata: {
		name:      string
		namespace?: string | *"default"
		labels?: {
			app: string
		}
	}

	data: {
		[string]: string
	}
}