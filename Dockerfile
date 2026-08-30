FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    build-essential wget git \
    libxml2-dev libxslt1-dev zlib1g-dev libsasl2-dev libldap2-dev \
    libssl-dev libjpeg-dev libpq-dev libffi-dev \
    node-less npm fonts-noto-cjk \
    && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && apt-get install -y ./wkhtmltox_0.12.6.1-3.bookworm_amd64.deb \
    && rm -rf /var/lib/apt/lists/* wkhtmltox_0.12.6.1-3.bookworm_amd64.deb

WORKDIR /opt/odoo
COPY odoo/ /opt/odoo/
COPY custom_addons/ /mnt/extra-addons/
RUN pip install --no-cache-dir "cython<3" wheel
RUN pip install --no-cache-dir --no-build-isolation gevent==21.8.0
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8069
ENTRYPOINT ["python3", "odoo-bin"]