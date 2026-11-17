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
    && sed -i 's/23f575a9a00a6b5ba8e607e55d05026e133840ce757bb23f88bc4014839a6aa8/e2dec50d027a7c1136e81f8e0f68f7ddf2bed66380a72a311c93300625bdbf74/g' scripts/build_hub_data.py \
    && python -m py_compile scripts/build_hub_data.py

EXPOSE 8080
CMD ["bash", "/app/start-hub-data.sh"]
