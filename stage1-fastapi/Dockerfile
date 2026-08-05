# ==========================================
# STAGE 1: Builder (Cài đặt & Đóng gói)
# ==========================================
FROM python:3.11-alpine3.20 AS builder

WORKDIR /app

# Tạo Virtual Environment độc lập
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip & cài đặt dependencies vào /opt/venv
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2" && \
    pip install --no-cache-dir -r requirements.txt

# ==========================================
# STAGE 2: Runner (Runtime siêu sạch & an toàn)
# ==========================================
FROM python:3.11-alpine3.20 AS runner

WORKDIR /app

# Copy Virtual Environment đã sạch lỗ hổng từ Stage Builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Tạo Non-root User theo nguyên tắc PoLP
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy Source Code và gán quyền trực tiếp cho appuser
COPY --chown=appuser:appgroup . .

# Chuyển sang User thường
USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
