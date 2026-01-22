# AWS ECS Setup (Cluster, Task Definition & Service)

This guide walks you through creating a basic **AWS ECS** (Elastic Container Service) setup to run the Docker image pushed by the Jenkins pipeline from **ECR**.

### 1. Create ECS Cluster

1. Go to AWS Console → **Elastic Container Service** (ECS)
2. Click **Clusters** → **Create Cluster**
3. Select **Networking only** → **AWS Fargate (serverless)**
4. Cluster name: `vprofile` (matches `cluster = "vprofile"` in Jenkinsfile)
5. Leave other settings default
6. Click **Create**

![ECS Cluster Overview](./screenshots/ecs-deployment.png)

### 2. Create Task Definition

1. In ECS → **Task Definitions** → **Create new task definition** → **Create new task definition with JSON** (or use wizard)
2. Use **Fargate** launch type
3. Basic configuration (minimal example):

   - **Task Definition Family**: `vprofile-app-task`
   - **Task Role**: None (or create IAM role with CloudWatch Logs access if needed)
   - **Task Execution Role**: Create or use `ecsTaskExecutionRole` (must have `AmazonECSTaskExecutionRolePolicy`)

   Container Definitions (add one container):

   - **Container name**: `vprofile-app`
   - **Image URI**: `354918401592.dkr.ecr.us-east-1.amazonaws.com/app-rg:latest`  
     (update with your account ID/repo — use `:latest` or specific tag)
   - **Memory Limits**: Soft 512 MiB, Hard 1024 MiB (adjust as needed)
   - **CPU**: 0.5 vCPU (512 units)
   - **Port mappings**: 8080 container port → 8080 host port (protocol TCP)
   - **Essential**: Yes

   Logging (recommended):
   - Log driver: **awslogs**
   - Log group: `/ecs/vprofile-app-task` (auto-created or pre-create)
   - Region: us-east-1

4. Click **Create**

![ECS Task Definition](./screenshots/ecs-task-definition.png)

**IAM Role Requirement**:
- Attach `CloudWatchLogsFullAccess` or minimal logging policy to the Task Execution Role
- Also ensure `AmazonEC2ContainerRegistryReadOnly` for pulling from ECR

### 3. Create ECS Service

1. Go to your cluster (`vprofile`) → **Services** tab → **Create**
2. Launch type: **Fargate**
3. Task Definition: Select family `vprofile-app-task` and latest revision
4. Service name: `vprofile-app-task-service` (matches `service = "vprofile-app-task-service"` in Jenkinsfile)
5. Number of tasks: 1 (for testing)
6. Networking:
   - VPC: Default or your VPC
   - Subnets: Public subnets (for simplicity — add ALB later for production)
   - Security group: Create one allowing inbound TCP 8080 from anywhere (0.0.0.0/0) for testing
   - Auto-assign public IP: **ENABLED** (so you can access the app)
7. Load balancing: Skip for now (add Application Load Balancer later if needed)
8. Click **Create Service**

![ECS Service Running](./screenshots/ecs-task-service.png)

### Verification

1. After service creation → wait for task status to become **RUNNING**
2. Click on the running task → find **Public IP** or **ENI public IP**
3. Open browser: `http://<public-ip>:8080`
   - You should see the vProfile application running!

