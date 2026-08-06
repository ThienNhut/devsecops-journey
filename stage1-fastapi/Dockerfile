# ==========================================
# STAGE 1: Builder
# ==========================================
FROM python:3.11-slim-bookworm AS builder

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2" "msgpack>=1.2.1" && \
    pip install --no-cache-dir -r requirements.txt

# ==========================================
# STAGE 2: Runner
# ==========================================
FROM python:3.11-slim-bookworm AS runner

WORKDIR /app

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Ép nâng cấp Python hệ thống TRƯỚC KHI nạp venv để xóa sạch bản 70.3.0 & 1.1.2 của Base Image
RUN /usr/local/bin/python3 -m pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2" "msgpack>=1.2.1"

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN groupadd -r appgroup && useradd -r -g appgroup appuser

COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
