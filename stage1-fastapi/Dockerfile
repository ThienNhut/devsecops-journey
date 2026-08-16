# ==========================================
# STAGE 1: Builder
# ==========================================
FROM python:3.11-slim AS builder

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt

# ==========================================
# STAGE 2: Runtime
# ==========================================
FROM python:3.11-slim AS runner

WORKDIR /app

# BỔ SUNG PYTHONPATH ĐỂ PYTHON ĐỌC ĐƯỢC CÁC PACKAGE TRONG /install
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/install/bin:$PATH" \
    PYTHONPATH="/install/lib/python3.11/site-packages:$PYTHONPATH"

# BẢO MẬT ISC2: Tạo Non-root user (Principle of Least Privilege)
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /bin/sh -m appuser

COPY --from=builder /install /install
COPY --chown=appuser:appgroup . /app

USER appuser

EXPOSE 8000

# Sửa đường dẫn chuẩn app.main:app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
