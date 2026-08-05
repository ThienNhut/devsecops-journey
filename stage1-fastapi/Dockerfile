# ==========================================
# STAGE 1: Builder (Build dependencies)
# ==========================================
FROM python:3.11-alpine3.20 AS builder

WORKDIR /app
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "wheel>=0.46.2" && \
    pip install --no-cache-dir -r requirements.txt

# ==========================================
# STAGE 2: Runner (Runtime siêu sạch)
# ==========================================
FROM python:3.11-alpine3.20 AS runner

WORKDIR /app

# Copy Virtual Environment từ Builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# HARDENING: Gỡ bỏ hoàn toàn wheel & setuptools thừa khỏi system Python của Stage 2
RUN pip uninstall -y wheel setuptools

# Tạo Non-root User (PoLP)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy Source Code và gán quyền cho appuser
COPY --chown=appuser:appgroup . .

USER appuser

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
