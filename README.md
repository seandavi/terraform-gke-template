This repo creates a google kubernetes cluster with workload identity activated.

To get going:

```sh
terraform init
terraform plan -out plan.out
terraform apply plan.out
```

Once up and running, add kubernetes context:

```sh
gcloud container clusters get-credentials cluster-1 --zone us-central1-f
```

Looks like we still need to do the following:

```sh
PROJECT=omicidx-338300
KUB_SA=workload-identity-sa \
kubectl annotate serviceaccount default \
  --namespace default \
  iam.gke.io/gcp-service-account=$KUB_SA@$PROJECT.iam.gserviceaccount.com
```

## Testing

```sh
kubectl run -it test2 --image=gcr.io/cloud-builders/gsutil ls
```

Should list buckets
