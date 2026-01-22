# AWS ECR Repository Setup

This guide explains how to create and configure the **AWS Elastic Container Registry (ECR)** repository used in the pipeline to store Docker images.  
The pipeline pushes images to a private repository named `app-rg` (you can change the name if needed).

![Jenkins Pipeline Stages](./screenshots/jenkins-stages.png)

The Jenkinsfile references these ECR details:

```groovy
environment {
    registryCredential = 'ecr:us-east-1:awscreds'
    appRegistry = "354918401592.dkr.ecr.us-east-1.amazonaws.com/app-rg"
    vprofileRegistry = "https://354918401592.dkr.ecr.us-east-1.amazonaws.com"
    ...
}
```

Update the AWS account ID (`354918401592`) and repository name (`app-rg`) to match your own AWS account.

## Step-by-Step: Create ECR Repository

1. Log in to the **AWS Management Console**  
   https://console.aws.amazon.com

2. Go to **Elastic Container Registry** (search for "ECR" or navigate via Services)

3. Click **Create repository**

4. Configure:
   - **Visibility settings**: **Private** (recommended for production)
   - **Repository name**: `app-rg` (or your preferred name — must match `appRegistry` in Jenkinsfile)
   - **Image scan settings**: Enable **Scan on push** (good security practice)
   - Leave other settings default

5. Click **Create repository**

## Verify Repository Details

After creation:
- Repository URI will look like:  
  `354918401592.dkr.ecr.us-east-1.amazonaws.com/app-rg`
- Copy this URI — it should match the `appRegistry` value in the Jenkinsfile (without the tag).

## IAM Permissions (Already Configured in Jenkins)

The AWS credential used in Jenkins (`awscreds`) must have permissions to:

- Push images: `ecr:BatchCheckLayerAvailability`, `ecr:CompleteLayerUpload`, `ecr:InitiateLayerUpload`, `ecr:PutImage`, `ecr:UploadLayerPart`
- Authenticate: `ecr:GetAuthorizationToken`

The easiest way is to attach the managed policy:
- **AmazonEC2ContainerRegistryPowerUser** (or **AmazonEC2ContainerRegistryFullAccess** for simplicity in lab)

## Verification After Pipeline Run

1. Trigger the Jenkins pipeline
2. Wait for **Upload App Image** stage to complete successfully
3. Go to AWS Console → ECR → Repositories → `app-rg`
4. You should see:
   - Image tags: `<BUILD_NUMBER>` and `latest`
   - Image size, pushed time, etc.

Click on an image tag → **View push commands** (for manual testing if needed)
