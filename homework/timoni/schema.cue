package main

#ImageTag: (string & !~"latest$") |
    error("image.tag cannot be 'latest'")

#InstanceSchema: {
    namespace: string | *"default"
    values: {
        image: {
            repository: string & != ""
            tag:        #ImageTag
        }
        replicas: int & >=1 & <=10
    }
}

#BundleSchema: {
    _cluster: {
        name:  string
        group: #ClusterGroup
        uid:   string
    }

    instances: {
        [_: string]: #InstanceSchema
    }
}