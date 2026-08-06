# ==========================================
# STAGE 1: Builder
# ==========================================
FROM python:3.11-slim-bookworm AS builder

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# 1. Tạo venv trước
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# 2. Nâng cấp trực tiếp TRONG venv ngay sau khi khởi tạo
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2" "msgpack>=1.2.1" "jaraco.context>=6.1.0"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ==========================================
# STAGE 2: Runner
# ==========================================
FROM python:3.11-slim-bookworm AS runner

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Copy venv đã được vá hoàn chỉnh từ Builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Nâng cấp hệ thống Python gốc ở Stage 2 để xóa triệt để metadata cũ
RUN /usr/local/bin/python -m pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2" "msgpack>=1.2.1"

RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
