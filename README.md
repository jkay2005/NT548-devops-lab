# NT548-devops-lab

## Tổng quan

Repository này là một lab DevOps gồm:

- Phần hạ tầng Terraform trong thư mục `terraform/`
- Luồng CI/CD GitHub Actions trong `.github/workflows/`
- Ví dụ microservice trong `microservices/`

Stack Terraform tạo ra các thành phần sau:

- VPC
- Public subnet và private subnet
- Internet Gateway và NAT Gateway
- Route table và các association
- Security group
- EC2 cho bastion host và một node Kubernetes private

## Điều kiện cần trước khi chạy

Cài sẵn các công cụ sau:

- Terraform 1.5+
- AWS CLI
- Git
- Bash trên Windows nếu muốn chạy trực tiếp `terraform/scripts/terraform_test.sh`
  - Có thể dùng Git Bash hoặc WSL trên Windows

Bạn cũng cần AWS credentials có quyền tạo và xóa các tài nguyên như EC2, VPC, EIP, security group và networking liên quan.

## Cấu hình AWS Credentials

Bạn có thể cấu hình credentials theo một trong hai cách sau:

### Cách 1: Dùng AWS CLI profile

```bash
aws configure
```

Nhập các giá trị sau:

- AWS Access Key ID
- AWS Secret Access Key
- Default region name: `ap-southeast-1`
- Default output format: `json`

### Cách 2: Dùng biến môi trường

PowerShell:

```powershell
$env:AWS_ACCESS_KEY_ID = "YOUR_ACCESS_KEY"
$env:AWS_SECRET_ACCESS_KEY = "YOUR_SECRET_KEY"
$env:AWS_REGION = "ap-southeast-1"
```

Bash:

```bash
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
export AWS_REGION=ap-southeast-1
```

Kiểm tra quyền truy cập:

```bash
aws sts get-caller-identity
```

## Yêu cầu về key pair

Cấu hình Terraform có hỗ trợ `key_name` trong `terraform/terraform.tfvars` để gắn EC2 Key Pair vào instance.

Ví dụ:

```hcl
key_name = "nt548-devops-lab-key"
```

Ý nghĩa của nó:

- `key_name` là tên của EC2 Key Pair trên AWS, không phải file `.pem`
- File `.pem` là private key bạn giữ trên máy local
- Terraform không đọc file `.pem`
- File `.pem` dùng để SSH vào bastion EC2 sau khi instance được tạo

Cách tạo key pair:

1. Mở AWS Console
2. Vào EC2
3. Chọn `Key Pairs`
4. Tạo key pair mới
5. Đặt tên, ví dụ `nt548-devops-lab-key`
6. Tải file `.pem` về và lưu cẩn thận trên máy

Lưu ý quan trọng:

- Không commit file `.pem` lên Git
- Tên key pair phải tồn tại trong đúng AWS region mà Terraform đang dùng
- Nếu không khai báo `key_name`, EC2 sẽ được tạo mà không gắn SSH key

## Cấu hình dự án

Sửa file `terraform/terraform.tfvars` trước khi chạy Terraform.

Ví dụ:

```hcl
aws_region   = "ap-southeast-1"
project_name = "nt548-devops-lab"
environment  = "lab"
my_ip_cidr   = "203.0.113.10/32"

public_subnet_cidrs  = ["10.0.1.0/24"]
private_subnet_cidrs = ["10.0.101.0/24"]

# Optional
key_name = "nt548-devops-lab-key"
# availability_zones = ["ap-southeast-1a"]
```

`my_ip_cidr` phải là IP public của bạn ở dạng CIDR. Giá trị này dùng để chỉ cho phép SSH từ IP của bạn vào public security group.

## Chạy local

Các lệnh Terraform bên dưới nên được chạy trong thư mục `terraform/` nếu không có ghi chú khác.

### 1. Khởi tạo Terraform

```bash
cd terraform
terraform init
```

### 2. Kiểm tra và tạo plan

Dùng script hỗ trợ từ thư mục gốc repository:

```bash
bash terraform/scripts/terraform_test.sh
```

Script này sẽ chạy:

- `terraform init -backend=false`
- `terraform validate`
- `terraform plan -out=tfplan`

Nếu bạn dùng Windows mà chưa có Bash trong `PATH`, hãy chạy bằng Git Bash hoặc WSL.

### 3. Xem nội dung plan

```bash
cd terraform
terraform show tfplan
```

### 4. Áp dụng hạ tầng

```bash
cd terraform
terraform apply tfplan
```

Hoặc áp dụng trực tiếp:

```bash
cd terraform
terraform apply -auto-approve
```

Sau khi apply xong, Terraform sẽ in ra các output như public IP của bastion và private IP của node private.

## SSH vào bastion

Nếu bạn đã khai báo `key_name`, bạn có thể SSH vào bastion bằng file `.pem` tương ứng.

Ví dụ:

```bash
ssh -i C:\path\to\nt548-devops-lab-key.pem ec2-user@<bastion_public_ip>
```

Lưu ý:

- Dùng đúng file private key bạn tải từ AWS
- Trên Windows, chỉ cần giữ file `.pem` ở một thư mục an toàn trên máy và trỏ đúng đường dẫn khi SSH
- User mặc định của Amazon Linux là `ec2-user`

## K3s / Node Kubernetes

EC2 private sử dụng `user_data` để tự động cài K3s khi khởi động.

Cách này giúp lab nhẹ hơn và tránh dùng EKS, tiết kiệm chi phí hơn.

## Xóa tài nguyên

Khi làm xong lab, hãy xóa toàn bộ tài nguyên để tránh phát sinh chi phí, đặc biệt là NAT Gateway và EC2.

```bash
cd terraform
terraform destroy -auto-approve
```

Nếu muốn kiểm tra state trước:

```bash
cd terraform
terraform state list
```

## GitHub Actions

Repository có file `.github/workflows/main.yml` cho CI/CD.

Workflow này thực hiện:

- `terraform validate`
- `terraform plan`
- Quét bảo mật bằng Checkov
- `terraform apply` khi push lên nhánh `main`

Trước khi dùng workflow, hãy cấu hình các GitHub Secrets sau:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

## Khắc phục lỗi thường gặp

- Nếu `terraform/scripts/terraform_test.sh` lỗi trên PowerShell Windows, hãy chạy bằng Git Bash hoặc WSL
- Nếu SSH lỗi, hãy kiểm tra `key_name` có tồn tại trong đúng region AWS và bạn đang dùng đúng file `.pem`
- Nếu không SSH được vào bastion, hãy kiểm tra lại `my_ip_cidr` có đúng với IP public hiện tại của bạn không