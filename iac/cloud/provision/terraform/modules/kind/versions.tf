terraform {
  required_providers {
    # kind = {
    #   source  = "kyma-incubator/kind"
    #   version = "~> 0.0.9"
    # }

    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.0.12"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }

  required_version = ">= 1.0.0"
}
