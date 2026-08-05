# Sử dụng Alpine Base Image siêu nhẹ & an toàn
FROM python:3.11-alpine

WORKDIR /app

# Upgrade pip, setuptools và wheel lên bản an toàn để vá CVE-2026-24049
RUN pip install --upgrade pip setuptools "wheel>=0.46.2"

# Tạo non-root user (Cú pháp Alpine dùng addgroup/adduser)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Cài đặt dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Chuyển sang user thường (PoLP)
USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
