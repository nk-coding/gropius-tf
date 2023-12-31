provider "kubernetes" {
  config_path = "./kubeconfig.yaml"
}
provider "helm" {
  kubernetes {
    config_path = "./kubeconfig.yaml"
  }
}

resource "kubernetes_namespace" "gropius" {
  metadata {
    name = "gropius"
  }
}