runtime: {
    apiVersion: "v1alpha1"
    name:       "fleet"
    clusters: {
        "kind-helpfwdays-homework": {
            group:       "staging"
            kubeContext: "kind-helpfwdays-homework"
        }
        "kind-helpfwdays-homework-prod": {
            group:       "production"
            kubeContext: "kind-helpfwdays-homework-prod"
        }
    }
    values: [
        {
            query: "k8s:v1:Namespace:default"
            for: {
                "CLUSTER_UID": "obj.metadata.uid"
            }
        },
    ]
}