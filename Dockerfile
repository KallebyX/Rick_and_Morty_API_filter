FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

RUN apt-get update \
    && apt-get install -y --no-install-recommends xz-utils ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN python -m pip install --no-cache-dir requests \
    && mkdir -p scripts \
    && cat compressed_pipeline/part_*.b64 | base64 --decode | xz --decompress > scripts/build_hub_data.py \
    && python -m py_compile scripts/build_hub_data.py

EXPOSE 8080
CMD ["bash", "/app/start-hub-data.sh"]
