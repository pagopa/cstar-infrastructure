# iac pipelines

The core of iac pipelines (code review and deploy) have been defined in `base-[code-review|deploy]-pipelines.yml`;
to decline your own pipeline for your specific domain you have to define the 2 related files (one for each pipeline) containing the following blocks:



- parameters:
```yaml
parameters:
  - name: 'DEV'
    displayName: 'Run on DEV environment'
    type: boolean
    default: True
    values:
      - False
      - True
  - name: 'UAT'
    displayName: 'Run on UAT environment'
    type: boolean
    default: True
    values:
      - False
      - True
  - name: 'PROD'
    displayName: 'Run on PROD environment'
    type: boolean
    default: True
    values:
      - False
      - True
```

- pool:
```yaml
pool:
  vmImage: 'ubuntu-latest'
```
- resources:
```yaml
resources:
  repositories:
    - repository: terraform
      type: github
      name: pagopa/azure-pipeline-templates
      ref: refs/tags/v6.8.0
      endpoint: "azure-devops-github-ro"
```

- pipeline content **code review:**
```yaml
stages:
  # one for each environment
  - ${{ if eq(parameters['DEV'], true) }}:
      - template: './base-code-review-pipelines.yml'
        parameters:
          ENV: "dev"
          WORKING_DIR_APP: "src/domains/mil-app-poc" #your app folder
          WORKING_DIR_COMMON: "src/domains/mil-common-poc" #your common folder
          WORKING_DIR_SECRET: "src/domains/mil-secrets-poc" #your secret folder
          SC_PLAN_NAME: '$(TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV)' #this env plan service connection
          POOL_NAME: '$(TF_POOL_NAME_DEV)' #dev agent pool name
          #this env aks details, optional
          AKS_APISERVER_URL: '$(TF_DEV_AKS_APISERVER_URL)' #this env aks details
          AKS_AZURE_DEVOPS_SA_CACRT: '$(TF_DEV_AKS_AZURE_DEVOPS_SA_CACRT)'
          AKS_AZURE_DEVOPS_SA_TOKEN: '$(TF_DEV_AKS_AZURE_DEVOPS_SA_TOKEN)'
          AKS_NAME: '$(TF_AKS_DEV_NAME)'
```

- pipeline content **deploy:**
```yaml
stages:
  #DEV
  - ${{ if eq(parameters['DEV'], true) }}:
    - template: './base-deploy-pipelines.yml'
      parameters:
        ENV: 'dev'
        WORKING_DIR_APP: "src/domains/mil-app-poc" #your app folder
        WORKING_DIR_COMMON: "src/domains/mil-common-poc" #your common folder
        WORKING_DIR_SECRET: "src/domains/mil-secrets-poc" #your secret folder
        DOMAIN_NAME: 'mil' #your domain name
        SC_PLAN_NAME: '$(TF_AZURE_SERVICE_CONNECTION_PLAN_NAME_DEV)' #this env plan service connection
        SC_APPLY_NAME: '$(TF_AZURE_SERVICE_CONNECTION_APPLY_NAME_DEV)' #this env apply service connection
        POOL_NAME: '$(TF_POOL_NAME_DEV)' #this env agent pool name
        #this env aks details, optional
        AKS_APISERVER_URL: '$(TF_DEV_AKS_APISERVER_URL)'
        AKS_AZURE_DEVOPS_SA_CACRT: '$(TF_DEV_AKS_AZURE_DEVOPS_SA_CACRT)'
        AKS_AZURE_DEVOPS_SA_TOKEN: '$(TF_DEV_AKS_AZURE_DEVOPS_SA_TOKEN)'
        AKS_NAME: '$(TF_AKS_DEV_NAME)'
```

### Customizations

This is the list of additional parameters that can be passed to the `base-*` pipelines to customize them

| parameter                  | description                                                          | default value |
|----------------------------|----------------------------------------------------------------------|---------------|
| ENV_LOCATION               | region location short                                                | itn           |
| TIME_OUT                   | pipeline time out                                                    | 15            |


## How to expand

### I need to run a pipeline on a folder different from 'app', 'common' or 'secret'

Follow these steps:

- add a new block in the `base-*` pipelines taking your new folder name into account (eg: folder "something")
This example is based on the `base-code-review-pipelines` file, for `base-deploy-pipelines` use a block similar to the one already defined
```yaml
      - job: tfplan_something #changeme
        condition: ne('${{parameters.WORKING_DIR_SOMETHING}}', '') #changeme
        strategy:
          parallel: 1
        timeoutInMinutes: $[variables.TIME_OUT]
        steps:
          - checkout: self
          # 1. Install terraform
          - template: templates/terraform-setup/template.yaml@terraform
          - template: templates/terraform-summarize/template.yaml@terraform
          # 2. Run terraform plan core
          - template: templates/terraform-plan/template.yaml@terraform
            parameters:
              TF_ENVIRONMENT_FOLDER: "${{parameters.ENV_LOCATION}}-${{lower(parameters.ENV)}}"
              WORKINGDIR: ${{ parameters.WORKING_DIR_SOMETHING }} #changeme
              AZURE_SERVICE_CONNECTION_NAME: "${{parameters.SC_PLAN_NAME}}"
              TF_SUMMARIZE: true
              AKS_NAME: ${{ parameters.AKS_NAME }}
              AKS_API_SERVER_URL: ${{ parameters.AKS_APISERVER_URL }}
              AKS_AZURE_DEVOPS_SA_CA_CRT: ${{ parameters.AKS_AZURE_DEVOPS_SA_CACRT }}
              AKS_AZURE_DEVOPS_SA_TOKEN: ${{ parameters.AKS_AZURE_DEVOPS_SA_TOKEN }}
```
- add an optional parameter like the following
```yaml
  - name: 'WORKING_DIR_SOMETHING' #changeme
    displayName: 'something domain working dir'
    type: string
    default: ''
```

### I need to add variables from the pipeline definition

No worries, once you've added the additional variables for your domain in the pipeline definition (check the `README.md` on cstar-platform-azure-devops project for the how-to)
you can add them in the `base-*` pipelines. If other domains don't use those variables is ok, it will do no harm to their pipeline execution
