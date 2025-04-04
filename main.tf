terraform {
   backend "http" 
   {
      address = ${{vars.TERRAFORM_STATE_FILE}}
      update_method = "PUT"
    }      
}
module "oke" {
  source  = "oracle-terraform-modules/oke/oci"
  version = "5.1.5"

  # Provider
  providers           = { oci.home = oci.home }
  home_region         = var.home_region
  region              = var.region
  tenancy_id          = var.tenancy_id
  compartment_id      = var.compartment_id
  ssh_public_key      = var.ssh_public_key
  ssh_private_key_path = var.ssh_private_key_path
   
  
 
  vcn_name      = "oke-vcn"
  
  #subnets
  subnets = {
    bastion  = { newbits = 13, netnum = 0, dns_label = "bastion" }
    operator = { newbits = 13, netnum = 1, dns_label = "operator" }
    cp       = { newbits = 13, netnum = 2, dns_label = "cp" }
	int_lb   = { newbits = 11, netnum = 16, dns_label = "ilb" }
	pub_lb   = { newbits = 11, netnum = 17, dns_label = "plb" }
    workers  = { newbits = 2, netnum = 1, dns_label = "workers" }
  }

  assign_dns           = true
  
  
  # bastion host
  create_bastion        = true
  bastion_allowed_cidrs = ["0.0.0.0/0"]
  bastion_upgrade       = false
  bastion_image_os            = "Oracle Linux" 
  bastion_image_os_version    = "8"            
  bastion_image_type          = "platform"
  bastion_shape = {
  shape            = "VM.Standard.E4.Flex",
  ocpus            = 2,
  memory           = 4,
  boot_volume_size = 50
  }
  
  
  #operator host
  create_operator            = true
  operator_upgrade           = false
  create_iam_resources       = true
  create_iam_operator_policy = "always"
  operator_install_k9s       = true
  operator_image_os              = "Oracle Linux" 
  operator_image_os_version      = "8"            
  operator_image_type            = "platform"
  operator_shape = {
  shape            = "VM.Standard.E4.Flex",
  ocpus            = 2,
  memory           = 4,
  boot_volume_size = 50
  }
  
  
  create_cluster       = true 
  kubernetes_version = var.kubernetes_version
  cluster_type = var.cluster_type
  
  allow_worker_ssh_access     = true 
  use_defined_tags     = false


  #node pools
  worker_pools = {
  
  np1 = {
    shape              = "VM.Standard.E4.Flex",
    ocpus              = 2,
    memory             = 8,
    size               = 1,
    boot_volume_size   = 50,
	
  }
  

   
  }
}