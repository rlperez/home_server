job "hello-world" {
  datacenters = ["homelab"]
  type        = "service"

  group "web" {
    network {
      port "http" {
        static = 8080
      }
    }

    task "server" {
      driver = "podman"

      config {
        image = "docker.io/hashicorp/http-echo:latest"
        ports = ["http"]
        args  = [
          "-listen", ":${NOMAD_PORT_http}",
          "-text", "Hello from Nomad and Podman! The cluster is ALIVE!"
        ]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
