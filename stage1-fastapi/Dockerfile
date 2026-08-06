# ==========================================
# STAGE 1: Builder
# ==========================================
FROM python:3.11-alpine3.20 AS builder

WORKDIR /app

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Nâng cấp trực tiếp wheel & setuptools lên bản an toàn bên trong venv
RUN pip install --no-cache-dir --upgrade pip setuptools "wheel>=0.46.2"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# ==========================================
# STAGE 2: Runner
# ==========================================
FROM python:3.11-alpine3.20 AS runner

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Tạo Non-root User
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
