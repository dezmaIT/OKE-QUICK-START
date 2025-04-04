## Create the OKE Clusters

1. Copy the terraform.tfvars.example to terraform.tfvars and provide the necessary values as detailed in steps 2-7.

```

cp terraform.tfvars.example terraform.tfvars

```

2. Configure the provider parameters:

```

# provider

home_region = "eu-frankfurt-1"

region = "eu-frankfurt"

tenancy_id = "ocid1.tenancy.oc1.."

compartment_id = "ocid1.compartment.oc1.."


```

3. Configure an ssh key pair:
```

ssh-keygen -b 2048 -t rsa -f <<sshkeyname>>

```
Add the keys to the terraform.tfvars file

```

# ssh
ssh_private_key_path = "~/.ssh/id_rsa"
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2E....."

```


5. Configure variable.ft parameters.<br>

```
 variable kubernetes_version { default = "v1.32.1" }
 variable cluster_type { default = "enhanced" }
 variable cluster_name { default = "oke-cluster" }
 variable cni_type {default = "flannel"}

```

6. Configure your bastion and operator shapes on main.tf file:

```

bastion_shape = {
  shape            = "VM.Standard.A2.Flex",
  ocpus            = 1,
  memory           = 4,
  boot_volume_size = 50
  }

operator_shape = {
  shape            = "VM.Standard.A2.Flex",
  ocpus            = 1,
  memory           = 4,
  boot_volume_size = 50
  }

```

7. Run terraform to create your clusters:

```

terraform init

terraform plan -var-file="terraform.tfvars"

terraform apply -var-file="terraform.tfvars"

```

8. Access your Cluster from the Operator

```
ssh -o ProxyCommand='ssh -W %h:%p -i <path-to-private-key> opc@<bastion_public_ip>' -i <path-to-private-key> opc@<operator_ip>

```


9. #<b>Optional</b> </br>

Clean up all resources if need be

```

 terraform destroy -var-file="terraform.tfvars"
```

