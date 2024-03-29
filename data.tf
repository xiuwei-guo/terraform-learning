
# 查询 centos 镜像ID
data "oci_core_images" "list_image" {
  compartment_id = var.compartment_id
  operating_system = "CentOS"
  operating_system_version = 7
  state = "AVAILABLE"
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_id
}