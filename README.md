# nginx-ingress-kubernetes-terraform
Terraform module which deploys NGINX Ingress to a Kubernetes cluster, [NGINX](https://nginx.org/) is a modern HTTP web server, reverse proxy and load balancer made to deploy microservices with ease.

# Description

This Terraform module makes it easy to deploy the [NGINX Ingress](https://github.com/kubernetes/ingress-nginx/) HelmChart into a Kubernetes cluster which can you call as a chile module in your Terraform configuration.

As Nginx Ingress has many configuration values by default we deploy the HelmChart as is with only two main input variables (Namespace, Replica Count).

By default the HelmChart NGINX Ingress [values.yaml](https://github.com/kubernetes/ingress-nginx/blob/HEAD/charts/ingress-nginx/values.yaml) is used but if you want to configure NGINX Ingress in your root module/configuration you can place your custom values.yaml file inside your root dir and add set the input variable (default_values) to any value. This will cause the nginx-ingress-terraform module to load your `values.yaml` file and configure the nginx-ingress deployment/services/pods etc to the values you provided.

# Requirements

- Terraform 0.13+
- Kubernetes Cluster

## How to use

The module makes use of the [Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) and the [Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) which looks for Kubernetes configuration in the following location ```"~/.kube/config"```, The Helm provider needs to be configured with the path to your kube config in a provider block in your Terraform configuration.

```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
```

### Create a Terraform Configuration
---

Create a new directory

```shell
$ mkdir example-deployment
```

Change into the directory

```shell
$ cd example-deployment
```

Create a file for the configuration code

```shell
$ touch main.tf
```

Paste the following configuration into ```main.tf``` and save it.

```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "nginx-ingress" {
  source = "github.com/vesavlad/nginx-ingress-terraform"

  replica_count = 2
}
```

Run terraform init

```shell
$ terraform init
```

Run terraform plan

```
$ terraform plan
```

Apply the Terraform configuration

```shell
$ terraform apply
```

### Custom Configuration Values
---

If you want to use your own configuration in `values.yaml` you will need to provide the default_values input variable to the module, the `nginx-ingress-terraform module` will detect its been told not to use the default values and will look for a file called `values.yaml` in your root dir. If you want to use a file with a different name, for example if you want differents values per workspace/environment you can provide the input `values_file` with the name of the file you want to use, an example is below.

```
$ tree
.
├── main.tf
└── values.yaml.tpl
```

You will then need to provide the default_values input to the module block in your main.tf file


```hcl
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config-elodin"
  }
}

module "nginx-ingress" {
  source = "github.com/vesavlad/nginx-ingress-terraform"

  replica_count  = 2

  default_values = "false"
}
```

If you want to use a file named other than `values.yaml` provide the input to the module like below

```hcl
module "nginx-ingress" {
  source         = "github.com/vesavlad/nginx-ingress-terraform"

  replica_count  = 2

  default_values = "false"
  values_file    = "beta-values.yaml"
}
```