# NT548-devops-lab
# Triển Khai CI/CD & Microservices

Phần này hướng dẫn cách thiết lập và chạy tự động quy trình CI/CD cho ứng dụng Microservices sử dụng Docker, Kubernetes, Jenkins và Sonar.

## 1. Yêu cầu hệ thống
Để chạy được dự án này cần cài đặt sẵn các công cụ:
- **Git**
- **Docker Desktop** (Phải bật tính năng **Enable Kubernetes** trong phần Settings).
- **Trình duyệt web** (Chrome/Edge/Firefox).

## 2. Cấu trúc thư mục liên quan
- `microservices/hello-world-api/`: Chứa mã nguồn ứng dụng Node.js, `Dockerfile` và thư mục `k8s/` chứa các cấu hình Kubernetes (`deployment.yaml`, `service.yaml`).
- `jenkins/`: Chứa file `docker-compose.yml` để khởi chạy Jenkins và SonarQube.

## 3. Hướng dẫn khởi chạy CI/CD

**Bước 1: Khởi động Jenkins và SonarQube**
Mở Terminal, đi chuyển vào thư mục `jenkins` và chạy lệnh sau để dựng các container:

cd jenkins
docker-compose up -d

**Bước 2: Lấy mật khẩu khởi tạo Jenkins**

docker exec -u 0 jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword

**Bước 3: Cài đặt ban đầu**
- Truy cập Jenkins tại: `http://localhost:8081`. Nhập mật khẩu vừa lấy và tạo tài khoản Admin.
- Truy cập SonarQube tại: `http://localhost:9000` (User/Pass mặc định: `admin`/`admin`). Tiến hành đổi mật khẩu ngay lần đầu đăng nhập.

## 4. Cấu hình kết nối

**Thiết lập SonarQube Token:**
1. Trong SonarQube, vào `My Account` > `Security` > `Generate Token` (Tên: `jenkins-token`, Loại: User Token).
2. Copy mã Token.
3. Trong Jenkins, vào `Manage Jenkins` > `Credentials` > Thêm Secret text chứa mã Token vừa copy (ID: `sonarqube-token`).
4. Vào `Manage Jenkins` > `System` > Thêm `SonarQube server` (Tên: `sonar-server`, URL: `http://sonarqube-server:9000`, chọn Token vừa tạo).

**Cài đặt Công cụ trong Jenkins:**
- Vào `Manage Jenkins` > `Tools` > Thêm `SonarQube Scanner` (Tên bắt buộc: `sonar-scanner`, tích chọn *Install automatically*).
- Đảm bảo Jenkins đã cài đặt các plugin: `Pipeline`, `Docker Pipeline`, `SonarQube Scanner`.

## 5. Chạy Pipeline CI/CD

1. Tại trang chủ Jenkins, tạo một Job mới loại **Pipeline** (Tên: `microservice-pipeline`).
2. Ở phần Pipeline Script, copy nội dung của file cấu hình Pipeline (đã được định nghĩa để thực hiện 4 Stages: *Checkout Code*, *SonarQube Analysis*, *Build Docker Image*, *Deploy to Kubernetes*).
3. Nhấn **Build Now**.

## 6. Kiểm tra Kết quả
- **Báo cáo Code:** Truy cập `http://localhost:9000` để xem kết quả quét mã nguồn (Bugs, Vulnerabilities, Code Smells).
- **Ứng dụng thực tế:** Mở trình duyệt và truy cập `http://localhost:30080` (Port được định nghĩa trong `service.yaml`). Nếu màn hình hiển thị JSON `{"message": "Hello World from Microservice!"...}` nghĩa là ứng dụng đã được Deploy thành công lên Kubernetes.

---
Chú thích Kỹ thuật :
Để Jenkins Container có thể giao tiếp và điều khiển được cụm Kubernetes của Docker Desktop (Host), file cấu hình `.kube/config` đã được copy vào Jenkins và cấu hình lại địa chỉ `127.0.0.1` thành `host.docker.internal`.
