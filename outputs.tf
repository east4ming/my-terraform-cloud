# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "generated_private_key_pem" {
  value     = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.private_key_pem
  sensitive = true
}

output "lb_public_ip" {
  value = [oci_load_balancer_load_balancer.free_load_balancer.ip_address_details]
}

output "app" {
  value = "http://${data.oci_core_vnic.app_vnic.public_ip_address}"
}
