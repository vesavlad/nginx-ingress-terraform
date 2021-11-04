variable "namespace" {
  description = "Namespace to install nginx ingress  chart into"
  type        = string
  default     = "ingress-nginx"
}

variable "replica_count" {
  description = "Number of replica pods to create"
  type        = number
  default     = 1
}

variable "default_values" {
  description = "Specifies whether to use the nginx ingress default values.yaml, or if set to anything else then to use your own custom values"
  type = string
  default = ""
}

variable "values_file" {
  description = "The name of the nginx ingress helmchart values file to use"
  type = string
  default = "values.yaml"
}