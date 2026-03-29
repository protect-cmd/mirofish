FROM python:3.11-slim

# Install Node.js and build tools
RUN apt-get update \
  && apt-get install -y --no-install-recommends nodejs npm gcc g++ \
  && rm -rf /var/lib/apt/lists/*

# Copy uv from official image
COPY --from=ghcr.io/astral-sh/uv:0.9.26 /uv /uvx /bin/

WORKDIR /app

# Copy dependency files first (layer cache)
COPY package.json package-lock.json ./
COPY frontend/package.json frontend/package-lock.json ./frontend/
COPY backend/pyproject.toml backend/uv.lock ./backend/

# Install Node deps + Python deps
# Install CPU-only PyTorch to avoid the 2.5GB CUDA version
RUN npm ci \
  && npm ci --prefix frontend \
  && cd backend \
  && uv sync --frozen --no-install-package torch --no-install-package torchvision --no-install-package torchaudio \
  && .venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Copy source code
COPY . .

EXPOSE 3000 5001

CMD ["npm", "run", "dev"]
