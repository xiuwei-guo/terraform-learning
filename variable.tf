variable "region" {
  type        = string
  description = "region"
}

variable "fingerprint" {
  type        = string
  description = "fingerprint"
}

variable "user_ocid" {
  type = string
  description = "user_ocid"
}

variable "tenancy_ocid" {
  type = string
  description = "tenancy_ocid"
}

variable "auth_private_key_path" {
  type = string
  description = "oci account auth private key path"
}

variable "auth_private_key" {
  type = string
  description = "oci account auth private key"
}

variable "compartment_id" {
  type = string
  description = "compartment_id"
}

variable "instance_ssh_public_keys" {
  type = string
  description = "public_keys"
}
