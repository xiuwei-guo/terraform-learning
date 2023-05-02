# output "print_image_id" {
#   value = data.oci_core_images.list_image.images[*].id 
#   description = "the last version image id"
# }


# output "vcn_id" {
#   value = oci_core_vcn.internal.id
#   description = "the vcn id"
# }