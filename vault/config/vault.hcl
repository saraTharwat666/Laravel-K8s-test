ui = true  #dashboard

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true  #lab "minikube"
}

storage "file" {
  path = "/vault/data"
}

api_addr = "http://0.0.0.0:8200"