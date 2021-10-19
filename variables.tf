### Common ###


variable "tenancy_ocid" {}
variable "region" {}
variable "target_compartment" {}

### General Network ###


variable "vcn_cidr_block" {
  
  default = "10.55.66.128/25"

}


variable "vcn_display_name" {
  
  default = "MB_DEV_VCN"

}
variable "vcn_dns_label" {
  
  default = "ffnsvcn"

}

variable "resource_tags" {

  type = map
  
}

variable "internet_gateway_enabled" {
  
  type    = bool
  default = true

}

variable "internet_gateway_display_name" {
  
  default = "FFNS_DEV_WEBAPP_IGW"

}

variable "route_table_display_name" {
  
  default = "FFNS_DEV_WEBAPP_ROUTE_TABLE"

}

variable "route_table_route_rules_description" {
  
  default = "FFNS_DEV_WEBAPP_ROUTE_RULES"

}

variable "route_table_route_rules_destination" {
  
  default = "0.0.0.0/0"
  

}

variable "route_table_route_rules_destination_type" {

  default = "CIDR_BLOCK"

}


### Compute Network ###

variable "demo_compute_subnet_cidr_block" {
  
  default = "10.55.66.128/28"
}

variable "demo_compute_subnet_display_name" {
  
  default = "FFNS_DEV_WEBAPP_SN"

}
variable "demo_compute_subnet_dns_label" {
  
  default = "ffnsuisubnet"

}

variable "demo_compute_instance_security_list_display_name" {
  
  default = "FFNS_DEV_WEBAPP_SL"
}

variable "demo_compute_instance_ingress_security_inbound_source_CIDR" {
  
  default = "0.0.0.0/0"

}

### Database Network ###

variable "demo_db_system_subnet_display_name" {
  
  default = "FFNS_DEV_DB_SN"
}

variable "demo_db_system_subnet_cidr_block" {
  
  default = "10.55.66.144/28"

}

variable "demo_db_system_subnet_prohibit_public_ip_on_vnic" {
  
  type    = bool
  default = true

}

variable "demo_db_system_subnet_dns_label" {
  
  default = "ffnsdbsubnet"
}

variable "demo_db_system_security_list_display_name" {
  
  default = "FFNS_DEV_DB_SL"
}

###
# Allow ingress only from DEMO Compute instance
###

variable "demo_db_system_ingress_security_inbound_source_CIDR" {
  
  default = "10.55.66.128/28"
}



