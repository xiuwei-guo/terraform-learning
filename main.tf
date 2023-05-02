terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region       = var.region
  fingerprint  = var.fingerprint
  user_ocid    = var.user_ocid
  tenancy_ocid = var.tenancy_ocid
  #private_key_path = var.auth_private_key_path
  private_key = var.auth_private_key
}

#创建一个vcn
resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "My internal VCN"
}


# 尝试创建一个子网
resource "oci_core_subnet" "dev_network" {
  vcn_id              = oci_core_vcn.internal.id
  cidr_block          = "10.0.0.0/24"
  compartment_id      = var.compartment_id
  display_name        = "Dev xiuwei"
  availability_domain = "doXN:US-ASHBURN-AD-1"
  dns_label           = "dev"
  route_table_id      = oci_core_route_table.internet_route_table.id
}

#创建一个drg 
resource "oci_core_drg" "drg_ashben" {
  compartment_id = var.compartment_id
}

#关联drg到vcn
resource "oci_core_drg_attachment" "drg_attachment" {
  drg_id = oci_core_drg.drg_ashben.id
  network_details {
    id   = oci_core_vcn.internal.id
    type = "VCN"
  }
}

# 创建一个igw 
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
}

# 路由表
resource "oci_core_route_table" "internet_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# 创建一个实例
module "compute-instance" {
  source  = "oracle-terraform-modules/compute-instance/oci"
  version = "2.4.1"
  # insert the 3 required variables here
  compartment_ocid            = var.compartment_id
  source_ocid                 = data.oci_core_images.list_image.images[0].id
  subnet_ocids                = [oci_core_subnet.dev_network.id]
  ssh_public_keys             = var.instance_ssh_public_keys
  instance_flex_memory_in_gbs = 1
  instance_flex_ocpus         = 1
  public_ip                   = "EPHEMERAL"
  shape                       = "VM.Standard.E4.Flex"
  count                       = 1
  instance_display_name       = "xiuwei.guo-test"
}



