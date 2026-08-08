FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1 \
    APP_HOME=/microservices/chat_db/ \
    PYMS_CONFIGMAP_FILE=/microservices/chat_db/config-docker.yml

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        g++ \
        git \
        libffi-dev \
        libssl-dev \
        python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY requirements*.txt ./
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements-docker.txt

COPY . .

EXPOSE 8080

CMD ["gunicorn", "--worker-class", "gevent", "--workers", "1", "--log-level", "INFO", "--bind", "0.0.0.0:8080", "manage:app"] 