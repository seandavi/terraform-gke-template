This repo creates a google kubernetes cluster with workload identity activated.

## Prerequisites

Needs a bucket for the terraform state to pre-exist

## Turning on

To get going:

```sh
terraform init
terraform plan -out plan.out
terraform apply plan.out
```

Once up and running, add kubernetes context:

```sh
gcloud container clusters get-credentials cluster-1 --region us-central1
```

Looks like we still need to do the following:

```sh
PROJECT=gap-som-dbmi-sd-app-fq9
KUB_SA=workload-identity-sa \
kubectl annotate serviceaccount default \
  --namespace default \
  iam.gke.io/gcp-service-account=$KUB_SA@$PROJECT.iam.gserviceaccount.com
```

## Testing

```sh
kubectl run -it test2 --image=gcr.io/cloud-builders/gsutil ls
kubectl delete pod/test2
```

Should list buckets and then delete test pod....

## Turning off

```sh
terraform destroy
```
