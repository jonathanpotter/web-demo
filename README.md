# Web Server Demo

Running a web server in Kubernetes. Nginx web server hosted in OpenShift connecting to external nfs volume.

# Usage

Create an `.env` file with these variables for the scripts.

```
IMAGE_REGISTRY=[your_image_registry_url]
ORG_NAME=[your_image_registry_org]
SUBDIR_LIST=[your_image_name]
IMAGE_TAG=[your_image_tag]
STORAGE_CLASS_NAME=[your_storage_class]
```

Authenticate to k8s namespace. Configure a pull secret and update `nginx/deployment.yaml`.

Run the script to build and deploy.

```
# Deploys app to K8s
./run.sh
```
