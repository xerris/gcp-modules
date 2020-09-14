# Simple GKE on GCP

About as simple as it gets :)

# Branch Model

Three branches exist that match the current state of that environment.

Pull requests are issued to each branch to approve the terraform plan that is output
when a pull request is started.

Only on an approval comment of `/gcbrun` will a terraform plan get applied to that
particular environment.

# Setup

Grant to the Cloud Build service account or the impersonated service account you are using to run terraform.

1. Need `container.clusters.create` permissions (for kubernetes admin)
1. Need `compute.networks.create` permissions (to create vpc)
1. Need `iam.serviceAccounts.user` permissions (to run service account)
1. Need `iam.serviceAccounts.create` permissions (to create sa for compute)
1. Need `Security Admin` role permission to add roles to sa account
2. Need to activate GKE api
