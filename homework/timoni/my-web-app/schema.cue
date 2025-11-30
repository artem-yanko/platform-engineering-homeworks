package main

#Schema: {
    // The number of pods replicas.
    // By default, the number of replicas is 1.
    // I'm adding a validation to ensure it's between 1 and 10.
	replicas: *1 | int & >=1 & <=10

    // The securityContext allows setting the container security context.
    // I'm adding a validation to ensure privileged containers are not allowed.
	securityContext: {
		privileged: *false | false
	}

    // App settings.
    // I'm adding a validation to ensure the message is not empty.
	message: string & !=""
}
