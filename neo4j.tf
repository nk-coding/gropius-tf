resource "random_password" "neo4j_password" {
  length  = 20
  special = true
}

resource "helm_release" "neo4j_db" {
  name       = "neo4j-db"
  repository = "https://helm.neo4j.com/neo4j"
  chart      = "neo4j"
  namespace  = kubernetes_namespace.gropius.metadata[0].name

  set {
    name  = "neo4j.edition"
    value = "community"
  }

  set {
    name  = "image.customImage"
    value = "ghcr.io/graphglue/neo4j:main"
  }

  set {
    name  = "image.imagePullPolicy"
    value = "Always"
  }

  set {
    name  = "neo4j.name"
    value = "gropius"
  }

  set {
    name  = "neo4j.password"
    value = random_password.neo4j_password.result
  }

  set {
    name  = "volumes.data.mode"
    value = "defaultStorageClass"
  }

  set {
    name  = "services.neo4j.enabled"
    value = "false"
  }

  set {
    name = "neo4j.resources.memory"
    value = "5Gi"
  }

  set {
    name = "neo4j.resources.cpu"
    value = "1.5"
  }

  set {
    name = "config.server\\.memory\\.heap\\.initial_size"
    value = "1G"
  }

  set {
    name = "config.server\\.memory\\.heap\\.max_size"
    value = "3G"
  }

  set {
    name = "config.server\\.memory\\.pagecache\\.size"
    value = "1G"
  }
}