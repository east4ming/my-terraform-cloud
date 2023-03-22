# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "~> 4.112.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }

  required_version = ">= 0.14.0"
}
