# ==========================================
# STAGE 1: Builder
# ==========================================
FROM python:3.11-alpine3.20 AS builder

WORKDIR /app

# Nâng cấp pip, setuptools, wheel ở cấp hệ thống
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2"

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ==========================================
# STAGE 2: Runner
# ==========================================
FROM python:3.11-alpine3.20 AS runner

WORKDIR /app

# Nâng cấp setuptools & wheel hệ thống ở Stage 2 để Trivy không quét ra bản 65.5.1 / 0.45.1
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2"

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Tạo Non-root User
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
