# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "tenancy_ocid" {
}

variable "user_ocid" {
  default = ""
}

variable "fingerprint" {
}

variable "private_key" {
  default = ""
}

variable "ssh_public_key" {
  default = ""
}

variable "compartment_ocid" {
}

variable "region" {
}

variable "instance_shape" {
  # default = "VM.Standard.A1.Flex" # Or VM.Standard.E2.1.Micro
  default = "VM.Standard.E2.1.Micro"
}

variable "instance_ocpus" {
  # VM.Standard.E2.1.Micro: 1(实际上是1/8)
  # VM.Standard.A1.Flex: 1
  default = 1 
}

variable "instance_shape_config_memory_in_gbs" { 
  # VM.Standard.E2.1.Micro: 1
  # VM.Standard.A1.Flex: 6
  default = 1 
}
