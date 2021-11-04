# Create nginx ingress namespace
resource "kubernetes_namespace" "nginx_ingress_namespace" {
  metadata {
    name = var.namespace
  }
}

# Install ingress-nginx helm_chart
resource "helm_release" "ingress-nginx" {
  namespace        = var.namespace
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"

  # If default_values == "" then apply default values from the chart if its anything else 
  # then apply values file using the values_file input variable
  values = [var.default_values == "" ? var.default_values : file("${path.root}/${var.values_file}")]

  set {
    name = "deployment.replicas"
    value = var.replica_count
  }

  depends_on = [
    kubernetes_namespace.nginx_ingress_namespace
  ]
}