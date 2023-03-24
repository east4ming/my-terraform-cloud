# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

/* Network */

resource "oci_core_virtual_network" "test_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "testVCN"
  dns_label      = "testvcn"
}

resource "oci_core_subnet" "test_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "testSubnet"
  dns_label         = "testsubnet"
  security_list_ids = [oci_core_security_list.test_security_list.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.test_vcn.id
  route_table_id    = oci_core_route_table.test_route_table.id
  dhcp_options_id   = oci_core_virtual_network.test_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "testIG"
  vcn_id         = oci_core_virtual_network.test_vcn.id
}

resource "oci_core_route_table" "test_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.test_vcn.id
  display_name   = "testRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_security_list" "test_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.test_vcn.id
  display_name   = "testSecurityList"

  egress_security_rules {
    # The transport protocol. 
    # Specify either `all` or an IPv4 protocol number as defined in Protocol Numbers. 
    # Options are supported only for ICMP ("1"), TCP ("6"), UDP ("17"), and ICMPv6 ("58").
    description = "allow all"
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    description = "internet ICMP"
    protocol    = "1"
    source      = "0.0.0.0/0"
  }

  ingress_security_rules {
    description = "internet ICMPv6"
    protocol    = "58"
    source      = "0.0.0.0/0"
  }

  ingress_security_rules {
    description = "VPC ICMP"
    protocol    = "1"
    source      = "10.1.0.0/16"
  }

  ingress_security_rules {
    description = "ssh"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    description = "TCP DNS"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      max = "53"
      min = "53"
    }
  }

  ingress_security_rules {
    description = "UDP DNS"
    protocol    = "17"
    source      = "0.0.0.0/0"

    udp_options {
      max = "53"
      min = "53"
    }
  }

  ingress_security_rules {
    description = "http"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }

  ingress_security_rules {
    description = "https"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      max = "443"
      min = "443"
    }
  }

  ingress_security_rules {
    description = "http test"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      max = "8090"
      min = "8080"
    }
  }

  ingress_security_rules {
    description = "k8s api"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      max = "6443"
      min = "6443"
    }
  }

  ingress_security_rules {
    description = "k8s kubectl metrics"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      max = "10250"
      min = "10250"
    }
  }

  ingress_security_rules {
    description = "k8s flannel"
    protocol    = "17"
    source      = "0.0.0.0/0"

    udp_options {
      max = "8472"
      min = "8472"
    }
  }

  ingress_security_rules {
    description = "wireguard"
    protocol    = "17"
    source      = "0.0.0.0/0"

    udp_options {
      max = "51830"
      min = "51820"
    }
  }

  ingress_security_rules {
    description = "tailscale"
    protocol    = "17"
    source      = "0.0.0.0/0"

    udp_options {
      max = "3478"
      min = "3478"
    }
  }

  ingress_security_rules {
    description = "tailscale"
    protocol    = "17"
    source      = "0.0.0.0/0"

    udp_options {
      max = "41641"
      min = "41641"
    }
  }
}

# user data
# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "user_data" {
  template = file("./userdata/bootstrap.tpl")
  vars = {
    tailscale_authkey = var.tailscale_authkey
  }
}

/* Instances */

resource "oci_core_instance" "free_instance_x86" {
  count               = var.instance_nums_x86
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "oci-free-x86-${count.index}"
  shape               = var.instance_shape_x86

  shape_config {
    ocpus         = var.instance_ocpus_x86
    memory_in_gbs = var.instance_shape_config_memory_in_gbs_x86
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.test_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "oci-free-x86-${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.test_images_x86.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
    user_data           = base64encode(data.template_file.user_data.rendered)
  }
}

# resource "oci_core_instance" "free_instance_arm" {
#   count               = var.instance_nums_arm
#   availability_domain = data.oci_identity_availability_domain.ad.name
#   compartment_id      = var.compartment_ocid
#   display_name        = "oci-free-arm-${count.index}"
#   shape               = var.instance_shape_arm

#   shape_config {
#     ocpus         = var.instance_ocpus_arm
#     memory_in_gbs = var.instance_shape_config_memory_in_gbs_arm
#   }

#   create_vnic_details {
#     subnet_id        = oci_core_subnet.test_subnet.id
#     display_name     = "primaryvnic"
#     assign_public_ip = true
#     hostname_label   = "oci-free-arm-${count.index}"
#   }

#   source_details {
#     source_type = "image"
#     source_id   = lookup(data.oci_core_images.test_images_arm.images[0], "id")
#   }

#   metadata = {
#     ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
#     user_data           = base64encode(data.template_file.user_data)
#   }
# }

resource "tls_private_key" "compute_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

/* Load Balancer */

resource "oci_load_balancer_load_balancer" "free_load_balancer" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "alwaysFreeLoadBalancer"
  shape          = "flexible"
  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }

  subnet_ids = [
    oci_core_subnet.test_subnet.id,
  ]
}

resource "oci_load_balancer_backend_set" "free_load_balancer_backend_set" {
  name             = "lbBackendSet1"
  load_balancer_id = oci_load_balancer_load_balancer.free_load_balancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }

  session_persistence_configuration {
    cookie_name      = "lb-session1"
    disable_fallback = true
  }
}

resource "oci_load_balancer_backend" "free_load_balancer_test_backend_x86" {
  #Required
  count            = length(oci_core_instance.free_instance_x86)
  backendset_name  = oci_load_balancer_backend_set.free_load_balancer_backend_set.name
  ip_address       = oci_core_instance.free_instance_x86[count.index].private_ip
  load_balancer_id = oci_load_balancer_load_balancer.free_load_balancer.id
  port             = "80"
}

# resource "oci_load_balancer_backend" "free_load_balancer_test_backend_arm" {
#   #Required
#   count            = length(oci_core_instance.free_instance_arm)
#   backendset_name  = oci_load_balancer_backend_set.free_load_balancer_backend_set.name
#   ip_address       = oci_core_instance.free_instance_arm[count.index].private_ip
#   load_balancer_id = oci_load_balancer_load_balancer.free_load_balancer.id
#   port             = "80"
# }

resource "oci_load_balancer_hostname" "test_hostname1" {
  #Required
  hostname         = "app.free.com"
  load_balancer_id = oci_load_balancer_load_balancer.free_load_balancer.id
  name             = "hostname1"
}

resource "oci_load_balancer_listener" "load_balancer_listener0" {
  load_balancer_id         = oci_load_balancer_load_balancer.free_load_balancer.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.free_load_balancer_backend_set.name
  hostname_names           = [oci_load_balancer_hostname.test_hostname1.name]
  port                     = 80
  protocol                 = "HTTP"
  rule_set_names           = [oci_load_balancer_rule_set.test_rule_set.name]

  connection_configuration {
    idle_timeout_in_seconds = "240"
  }
}

resource "oci_load_balancer_rule_set" "test_rule_set" {
  items {
    action = "ADD_HTTP_REQUEST_HEADER"
    header = "example_header_name"
    value  = "example_header_value"
  }

  items {
    action          = "CONTROL_ACCESS_USING_HTTP_METHODS"
    allowed_methods = ["GET", "POST"]
    status_code     = "405"
  }

  load_balancer_id = oci_load_balancer_load_balancer.free_load_balancer.id
  name             = "test_rule_set_name"
}

resource "tls_private_key" "example" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "example" {
  # key_algorithm   = "ECDSA" # read-only
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    organization = "Oracle"
    country      = "US"
    locality     = "Austin"
    province     = "TX"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
    "cert_signing"
  ]

  is_ca_certificate = true
}

resource "oci_load_balancer_certificate" "load_balancer_certificate" {
  load_balancer_id   = oci_load_balancer_load_balancer.free_load_balancer.id
  ca_certificate     = tls_self_signed_cert.example.cert_pem
  certificate_name   = "certificate1"
  private_key        = tls_private_key.example.private_key_pem
  public_certificate = tls_self_signed_cert.example.cert_pem

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_listener" "load_balancer_listener1" {
  load_balancer_id         = oci_load_balancer_load_balancer.free_load_balancer.id
  name                     = "https"
  default_backend_set_name = oci_load_balancer_backend_set.free_load_balancer_backend_set.name
  port                     = 443
  protocol                 = "HTTP"

  ssl_configuration {
    certificate_name        = oci_load_balancer_certificate.load_balancer_certificate.certificate_name
    verify_peer_certificate = false
  }
}

# See https://docs.oracle.com/iaas/images/
data "oci_core_images" "test_images_x86" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = var.instance_shape_x86
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_images" "test_images_arm" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = var.instance_shape_arm
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_database_autonomous_databases" "test_autonomous_databases" {
  #Required
  compartment_id = var.compartment_ocid

  #Optional
  db_workload  = "OLTP"
  is_free_tier = "true"
}

resource "oci_database_autonomous_database" "test_autonomous_database" {
  #Required
  admin_password           = "Testalwaysfree1"
  compartment_id           = var.compartment_ocid
  cpu_core_count           = "1"
  data_storage_size_in_tbs = "1"
  db_name                  = "testadb"

  #Optional
  db_workload  = "OLTP"
  display_name = "test_autonomous_database"

  freeform_tags = {
    "Department" = "Finance"
  }

  is_auto_scaling_enabled = "false"
  license_model           = "LICENSE_INCLUDED"
  is_free_tier            = "true"
}
