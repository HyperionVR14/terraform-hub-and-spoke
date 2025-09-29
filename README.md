# terraform-hub-and-spoke
Local repo for testing Terraform code to deploy Hub and Spoke infrastructure

Azure Hub-and-Spoke (DRY Terraform)
A minimal, clean, and DRY Terraform setup that builds:

1× Resource Group
3× VNets (Hub + 2 Spokes) with one subnet each
VNet peerings (Hub↔Spoke1, Hub↔Spoke2)
Storage Account in Hub with public access disabled + Private Endpoint
Key Vault in Hub + Private Endpoint
1× Linux VM in Hub (private IP only)
NSGs to restrict internal traffic only (deny inbound from Internet)
Private DNS Zones for Storage & Key Vault, linked to all VNets
Notes
No public IPs. VM reachable only from inside VNets (peered). If you need interactive access, add Azure Bastion or a jump host in the hub later.
One subnet per VNet as requested.

Repo Structure: 
azure-hub-spoke-terraform/
├─ main.tf
├─ variables.tf
├─ outputs.tf
├─ versions.tf
├─ terraform.auto.tfvars 
└─ modules/
├─ network/
│ ├─ main.tf
│ ├─ variables.tf
│ └─ outputs.tf
├─ peering/
│ ├─ main.tf
│ └─ variables.tf
├─ storage/
│ ├─ main.tf
│ ├─ variables.tf
│ └─ outputs.tf
├─ keyvault/
│ ├─ main.tf
│ ├─ variables.tf
│ └─ outputs.tf
└─ vm/
├─ main.tf
├─ variables.tf
└─ outputs.tf

Plan: 
1. Creation and deployment of placeholder / template Hub & Spoke infrastructure.
2. Deploy of application / container
3. Securing app / infrastructure as third step
   
