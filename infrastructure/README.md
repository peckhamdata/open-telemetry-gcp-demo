# Infrastructure

## Dependencies

* [Terraform](https://www.terraform.io/) v0.12.24+
* Google [Cloud SDK](https://cloud.google.com/sdk/)

## Before you begin

It is *essential* to make sure you are using the right Google Cloud Account otherwise any resources you create will end up in the wrong place or you'll end up destroying things you don't want to.

Check the active account with `gcloud auth list`

If the account you want to use is not listed you need to authorise it with `gcloud auth login`

Set the active account with `gcloud config set account [ACCOUNT]`

e.g. for working on the Non Prod account you should see something like this:

```
    Credentialed Accounts
ACTIVE  ACCOUNT
        chris@worldofchris.com
*       goat@goatfoo.com
```

## Create the GCP project.

In order for Terraform to have a project to refer to and build in you need to create
one:

```
export PROJECT_ID=otel-prince-charming
export PROJECT_NAME='Prince Charming'
gcloud projects create ${PROJECT_ID} --name="${PROJECT_NAME}"
```

Select the new project with `gcloud init`

## Enable billing on the project

Do this via the GCP console.

## Enable API services

```
gcloud services enable secretmanager.googleapis.com
gcloud services enable sourcerepo.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable iam.googleapis.com 
gcloud services enable cloudbuild.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable vpcaccess.googleapis.com
```

## Configure the Google Terraform Provider

The preferred method of provisioning resources with Terraform is to use a GCP [service account](https://console.cloud.google.com/iam-admin/serviceaccounts?folder=&organizationId=&project=api-goatfoo-com), a "robot account" that can be granted a limited set of IAM permissions.[1](https://www.terraform.io/docs/providers/google/guides/getting_started.html)

```
gcloud iam service-accounts create terraform --description="Terraform" --display-name="Terraform"
gcloud iam service-accounts keys create ${PROJECT_ID}.json --iam-account terraform@${PROJECT_ID}.iam.gserviceaccount.com 
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/owner
```

Put the newly created key file in your `~/gcloud` directory

Store the keys in Google Cloud Secrets:

```
gcloud secrets create ${PROJECT_ID}-keys --data-file ~/gcloud/${PROJECT_ID}.json --replication-policy automatic
```

## Store Terraform state in a Google Cloud Storage Bucket

For this we need to create a bucket:

```
gsutil mb -l europe-west1 gs://${PROJECT_ID}-tfstate/
gsutil versioning set on gs://${PROJECT_ID}-tfstate/
```

And grant the Terraform Service Account user access to the bucket:

```
gsutil iam ch serviceAccount:terraform@${PROJECT_ID}.iam.gserviceaccount.com:objectAdmin gs://${PROJECT_ID}-tfstate
```

## Deployment

Light the blue touch paper...

`terraform init`

`terraform apply`