# Sử dụng Alpine Base Image siêu nhẹ & an toàn
FROM python:3.11-alpine

WORKDIR /app

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
