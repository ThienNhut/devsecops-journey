# ==========================================
# STAGE 1: Builder
# ==========================================
FROM python:3.11-slim-bookworm AS builder

WORKDIR /app

# Patch bảo mật OS & nâng cấp công cụ build
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2"

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ==========================================
# STAGE 2: Runner
# ==========================================
FROM python:3.11-slim-bookworm AS runner

WORKDIR /app

# Patch bảo mật OS & dọn dẹp cache
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2"

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Tạo Non-root User chuẩn Debian (dùng groupadd/useradd thay cho Alpine adduser)
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
