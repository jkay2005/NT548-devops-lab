# Sử dụng image Node.js bản nhẹ (alpine)
FROM node:18-alpine

# Khai báo thư mục làm việc bên trong container
WORKDIR /usr/src/app

# Copy package.json và cài đặt thư viện
COPY package*.json ./
RUN npm install --production

# Copy toàn bộ mã nguồn vào container
COPY . .

# Mở port 3000 để bên ngoài có thể gọi vào
EXPOSE 3000

# Lệnh để khởi chạy ứng dụng
CMD [ "npm", "start" ]