# Phần Hạ Tầng AWS CloudFormation & CI/CD Pipeline
**Người thực hiện:** Kiên

# Giới thiệu
Thư mục này chứa mã nguồn IaC (Infrastructure as Code) sử dụng **AWS CloudFormation** để tự động hóa việc khởi tạo hạ tầng trên AWS. Đồng thời, thư mục này cũng chứa các file cấu hình để thiết lập luồng CI/CD tự động bằng **AWS CodePipeline** và **AWS CodeBuild**.

# Kiến trúc Hạ tầng (Lab 1)
File `templates/network.yaml` sẽ tự động khởi tạo các tài nguyên sau:
- **VPC** (CIDR: 10.0.0.0/16)
- **Public Subnet** (CIDR: 10.0.1.0/24) và **Private Subnet** (CIDR: 10.0.101.0/24)
- **Internet Gateway (IGW)** & **NAT Gateway** (kèm Elastic IP)
- **Route Tables** và **Security Groups**
- **EC2 Instance** (`t3.micro`) để phục vụ triển khai Kubernetes/Minikube.

# Hướng dẫn Cài đặt & Chạy lệnh (Local Test)
Nếu bạn muốn kiểm tra code trên máy tính cá nhân trước khi đẩy lên GitHub, hãy thực hiện các bước sau:

**1. Yêu cầu hệ thống:**
- Cài đặt [AWS CLI](https://aws.amazon.com/cli/) và cấu hình chứng chỉ (`aws configure`).
- Cài đặt Python 3.11.

**2. Cài đặt môi trường và công cụ:**
```bash
python -m venv venv
source venv/bin/activate  # (Dùng `venv\Scripts\activate` nếu dùng Windows)
pip install cfn-lint taskcat setuptools