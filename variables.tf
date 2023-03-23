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

# AlwayFree: 2个基于AMD的虚机，每个虚拟机配备1/8 OCPU和1GB内存

variable "instance_nums_x86" {
  default = 2
}

variable "instance_shape_x86" {
  default = "VM.Standard.E2.1.Micro"
}

variable "instance_ocpus_x86" {
  # VM.Standard.E2.1.Micro: 1(实际上是1/8)
  default = 1 
}

variable "instance_shape_config_memory_in_gbs_x86" { 
  # VM.Standard.E2.1.Micro: 1
  default = 1 
}

# AlwayFree: 基于 ARM 的 Ampere A1 内核和 24 GB 内存，最多 4 个虚机
# 每个 1C 6G
variable "instance_nums_arm" {
  default = 4
}

variable "instance_shape_arm" {
  default = "VM.Standard.A1.Flex"
}

variable "instance_ocpus_arm" {
  # VM.Standard.A1.Flex: 1
  default = 1 
}

variable "instance_shape_config_memory_in_gbs_arm" { 
  # VM.Standard.A1.Flex: 6
  default = 6
}
