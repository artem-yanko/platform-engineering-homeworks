package appnginx

import "github.com/ctrlops-io/cuehomework/homework/cue/schema"

configMap: schema.#KubernetesConfigMap & {
    metadata: {
        name: "nginx-cm"
        labels: {
            app: "nginx"
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
    <p>Hello world!<p>
</body>
</html>
"""
    }
}