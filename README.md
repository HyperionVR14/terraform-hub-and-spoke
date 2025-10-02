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

Plan: 
1. Creation and deployment of placeholder / template Hub & Spoke infrastructure.
2. Deploy of application / container
3. Securing app / infrastructure as third step
   
Tests:

Wait for 200 OK
Sends HTTP requests to the public URL with retries until it gets 200 OK, confirming the app is up and reachable post-deploy.

Check homepage content
Downloads the homepage (follows redirects) and searches for an expected marker (e.g., “Practical Exam Task”) to ensure your content is served, not a default page.

Kudu VFS index.html (GET)
Fetches index.html via the Kudu/SCM VFS API using Basic auth and expects HTTP 200, proving the file exists under /home/site/wwwroot.

Kudu VFS contains marker
Scans the downloaded index.html for the marker text to confirm the correct version of the page was deployed.

Kudu VFS buildinfo (200 + content + SHA)
Downloads _buildinfo.txt from VFS, validates HTTP 200, and checks it contains the current GITHUB_SHA (or its short form), linking the deployed artifact to this specific build.