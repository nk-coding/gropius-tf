resource "random_password" "mongo_password" {
  length  = 32
  special = false
}


resource "helm_release" "mongodb" {
  count = var.sync_github || var.sync_jira ? 1 : 0

  name       = "mongodb"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "mongodb"
  namespace  = kubernetes_namespace.gropius.metadata[0].name

  set {
    name  = "auth.enabled"
    value = "true"
  }

  set {
    name  = "auth.username"
    value = "gropius"
  }

  set {
    name  = "auth.password"
    value = random_password.mongo_password.result
  }

  set {
    name  = "auth.database"
    value = "gropius"
  }

  set {
    name  = "replicaSet.enabled"
    value = "false"
  }

  dynamic "set" {
    for_each = var.storage_class != null ? [var.storage_class] : []
    content {
      name  = "global.storageClass"
      value = set.value
    }
  }
}