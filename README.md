# gcp serverless example with terraform

<h3>dependency</h3>
<pre>
go get cloud.google.com/go/pubsub
</pre>

<h3>install gcloud</h3>
https://cloud.google.com/sdk/docs/install

https://cloud.google.com/sdk/docs/cheatsheet

<pre>
gcloud auth application-default login

gcloud auth list

gcloud config set project {project-id}
</pre>

<h3>deploy using terraform</h3>
<pre>
terraform init

terraform plan -var-file=dev.tfvars -out plan.out

terraform apply plan.out 
</pre>