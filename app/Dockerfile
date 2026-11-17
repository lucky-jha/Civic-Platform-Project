# ==========================================
# STAGE 1: Builder (Installs dependencies)
# ==========================================
FROM python:3.12-slim AS builder

# Get uv binary (pin the tag so builds don't break silently)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy ONLY dependency files first — layer cache stays valid
# until pyproject.toml or uv.lock changes.
COPY pyproject.toml uv.lock ./

# Install deps into /app/.venv
# --no-install-project: don't try to install the project itself yet (source isn't here)
# --frozen: fail if uv.lock is out of date with pyproject.toml (safety)
RUN uv sync --frozen --no-dev --no-install-project

# Now copy the source
COPY . .

# ==========================================
# STAGE 2: Runtime (The final, secure image)
# ==========================================
FROM python:3.12-slim AS runtime

WORKDIR /app

# Non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copy the ready-made venv from builder
COPY --from=builder --chown=appuser:appgroup /app/.venv /app/.venv

# Copy the application code
COPY --chown=appuser:appgroup . .

# venv on PATH so `uvicorn` resolves
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER appuser

EXPOSE 8000

# Adjust "main:app" if your file lives at app/app/main.py (then use "app.main:app")
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]