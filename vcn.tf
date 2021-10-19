// Copyright (c) 2017, 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

###
##  Configure an OCI VCN  
###
###     Create and configure a basic VCN with network requirements for the compute and DBCS instances in two different subnets


###
## General Network 
###


resource "oci_core_vcn" "demo_vcn" {
  

  cidr_block     = var.vcn_cidr_block
  compartment_id = var.target_compartment
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label

  defined_tags   = var.resource_tags.definedTags
  freeform_tags  = var.resource_tags.freeformTags

}



resource "oci_core_internet_gateway" "demo_vcn" {

    compartment_id = var.target_compartment
    vcn_id = oci_core_vcn.demo_vcn.id
    enabled = var.internet_gateway_enabled
    display_name = var.internet_gateway_display_name

    defined_tags   = var.resource_tags.definedTags
    freeform_tags  = var.resource_tags.freeformTags

}


resource "oci_core_default_route_table" "demo_vcn" {

  manage_default_resource_id = oci_core_vcn.demo_vcn.default_route_table_id

  display_name               = var.route_table_display_name

  defined_tags   = var.resource_tags.definedTags
  freeform_tags  = var.resource_tags.freeformTags

  route_rules {

    description       = var.route_table_route_rules_description
    destination       = var.route_table_route_rules_destination
    destination_type  = var.route_table_route_rules_destination_type
    network_entity_id = oci_core_internet_gateway.demo_vcn.id
  }
}


###
## Compute Network 
###


resource "oci_core_subnet" "demo_ui" {

  availability_domain = data.oci_identity_availability_domain.ad.name

  cidr_block          = var.demo_compute_subnet_cidr_block

  display_name        = var.demo_compute_subnet_display_name

  dns_label           = var.demo_compute_subnet_dns_label
  
  ## security_list_ids   = [oci_core_vcn.demo_vcn.default_security_list_id]

  security_list_ids   = [oci_core_security_list.demo_ui.id]
  
  compartment_id      = var.target_compartment

  vcn_id              = oci_core_vcn.demo_vcn.id

  route_table_id      = oci_core_vcn.demo_vcn.default_route_table_id

  dhcp_options_id     = oci_core_vcn.demo_vcn.default_dhcp_options_id
}


resource "oci_core_security_list" "demo_ui" {
  compartment_id = var.target_compartment
 
  vcn_id              = oci_core_vcn.demo_vcn.id

  display_name   = var.demo_compute_instance_security_list_display_name

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow outbound udp traffic on a port range
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17" // udp
    stateless   = true
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "1"
    stateless   = true
  }

  // allow inbound ssh traffic from a specific port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = var.demo_compute_instance_ingress_security_inbound_source_CIDR
    stateless = false
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = var.demo_db_system_ingress_security_inbound_source_CIDR
    stateless = true
  }
}


###
## DB Network 
###

resource "oci_core_subnet" "demo_db" {

  availability_domain = data.oci_identity_availability_domain.ad.name

  prohibit_public_ip_on_vnic = var.demo_db_system_subnet_prohibit_public_ip_on_vnic

  cidr_block          = var.demo_db_system_subnet_cidr_block

  display_name        = var.demo_db_system_subnet_display_name

  dns_label           = var.demo_db_system_subnet_dns_label
  
  security_list_ids   = [oci_core_security_list.demo_db.id]

  compartment_id      = var.target_compartment

  vcn_id              = oci_core_vcn.demo_vcn.id

  route_table_id      = oci_core_vcn.demo_vcn.default_route_table_id

  dhcp_options_id     = oci_core_vcn.demo_vcn.default_dhcp_options_id
}


###
## https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_security_list
###

resource "oci_core_security_list" "demo_db" {
  compartment_id = var.target_compartment
 
  vcn_id              = oci_core_vcn.demo_vcn.id

  display_name   = var.demo_db_system_security_list_display_name

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow outbound udp traffic on a port range
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17" // udp
    stateless   = true
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "1"
    stateless   = true
  }

  // allow inbound ssh traffic from a specific port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = var.demo_db_system_ingress_security_inbound_source_CIDR
    stateless = false
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = var.demo_db_system_ingress_security_inbound_source_CIDR
    stateless = true
  }
}



# Gets a list of Availability Domains
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}


