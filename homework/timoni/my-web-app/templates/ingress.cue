package templates

import (
	networkingv1 "k8s.io/api/networking/v1"
)

#Ingress: networkingv1.#Ingress & {
	#config:    #Config
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata:   #config.metadata
	if #config.ingress.annotations != _|_ {
		metadata: annotations: #config.ingress.annotations
	}
	spec: networkingv1.#IngressSpec & {
		ingressClassName: "nginx" // R.I.P. nginx ingress :')
		rules: [
			{
				host: #config.ingress.host
				http: networkingv1.#HTTPIngressRuleValue & {
					paths: [
						{
							path:     #config.ingress.path
							pathType: #config.ingress.pathType
							backend: networkingv1.#IngressBackend & {
								service: networkingv1.#IngressServiceBackend & {
									name: #config.metadata.name
									port: name: "http"
								}
							}
						},
					]
				}
			},
		]
	}
}
