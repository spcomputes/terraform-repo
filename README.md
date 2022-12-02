# POC on crossplane/provider-terraform
This POC is created to find the capability and constraints of provider-terraform

## Installation
### Prerequisite
  - Access to openshift cluster with rights to create resources.
  - AWS account with access credentials having resource creation access
  - Git repo
### Steps for installing
  - Install crossplane in the openshift cluster https://github.com/jeremycaine/crossplane-with-openshift/blob/main/1.%20Installing%20Crossplane%20on%20Openshift/README.md
  - Install provider-terraform https://github.com/crossplane-contrib/provider-terraform
### Run the POC
  - Checkout the code from git https://github.com/spcomputes/terraform-repo.git
  - open command prompt, login to openshift cluster
```sh
oc login --token=<token> --server=<server>
```
    - Setup secrets for git and aws
    - For setting up aws secret https://crossplane.io/docs/v1.10/getting-started/install-configure.html
    - For setting up git secret https://github.com/crossplane-contrib/provider-terraform
    - Apply providerconfig.yaml
    ```sh
    oc apply -f providerconfig.yaml
    ```
    - Apply workspace-remote.yaml
    ```sh
    oc apply -f workspace-remote.yaml
    ```
    - Check the status
    ```sh
    oc get workspaces
    ```
    - Note: Please check the AWS console after 3 mins to verify if the ec2 creation is successful.
### Troubleshoot
    - We may see the below error after installing the provider-terraform
    ```
    Warning  FailedCreate  35s (x16 over 2m39s)  replicaset-controller  Error creating: pods "crossplane-provider-terraform-6f2df84a9c2f-5b4b4bb774-" is forbidden: unable to validate against any security context constraint: [provider "anyuid": Forbidden: not usable by user or serviceaccount, spec.containers[0].securityContext.runAsUser: Invalid value: 2000: must be in the ranges: [1000800000, 1000809999], provider "ibm-restricted-scc": Forbidden: not usable by user or serviceaccount, provider "nonroot": Forbidden: not usable by user or serviceaccount, provider "ibm-anyuid-scc": Forbidden: not usable by user or serviceaccount, provider "hostmount-anyuid": Forbidden: not usable by user or serviceaccount, provider "ibm-anyuid-hostpath-scc": Forbidden: not usable by user or serviceaccount, provider "hostnetwork": Forbidden: not usable by user or serviceaccount, provider "hostaccess": Forbidden: not usable by user or serviceaccount, provider "ibm-anyuid-hostaccess-scc": Forbidden: not usable by user or serviceaccount, provider "node-exporter": Forbidden: not usable by user or serviceaccount, provider "ibm-privileged-scc": Forbidden: not usable by user or serviceaccount, provider "privileged": Forbidden: not usable by user or serviceaccount]
    ```
    - To tackle the above error create a new role in Openshift cluster and add actions to get, watch, list, create, update, delete, patch and attach it to RB



### Findings
#### Pros
    - Infrastructure state is managed by crossplane. Any changes made to AWS resources will be rollback by reconcilation process.
    - Default reconcilation process triggers for every 3 minutes (This is our observation, we need to deep dive to check where we can change)
    - Any changes to git terraform template will be applied with reconcilation process.
    - We can inject variable's value via 4 ways
        1. Inline in workspace
        2. ConfigMap
        3. Secret
        4. .tfvar file residing at git
        Note: We observed highest priority is given to "inline" when values are provided in inline and .tfvar file. We haven't tried configmap and secret
#### Cons
    - It is still an experimental crossplane provider, Its latest version is 0.5.0
    - You must either use remote state or ensure the provider container's /tf directory is not lost. provider-terraform does not persist state; consider using the [Kubernetes] remote state backend.
    - We are not able to see the event until after it has successfully applied the terraform module.
    - Setting --max-reconcile-rate to a value greater than 1 will potentially cause the provider to use up to the same number of CPUs. Add a resources section to the ControllerConfig to restrict CPU usage as needed. [Kubernetes]: https://www.terraform.io/docs/language/settings/backends/kubernetes.html [git credentials store]: https://git-scm.com/docs/git-credential-store
    - If the module takes longer than the value of --timeout (default is 20m) to apply the underlying terraform process will be killed. You will potentially lose state and leak resources. The workspace lock will also likely be left in place and need to be manually removed before the Workspace can be reconciled again.
### Conclusion




    