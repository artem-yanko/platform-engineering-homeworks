package schema

#Person: {
    name:     string
    age:      int & >=0 & <=120
    email:    string & =~"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    hobbies?: [...string]
}