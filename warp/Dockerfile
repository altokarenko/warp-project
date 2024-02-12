FROM python:3-slim AS compile-image

ENV NODE_VER=16.3.0

WORKDIR /opt/warp
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    libpq-dev \
    libpcre3 \
    libpcre3-dev \
    mime-support

RUN mkdir debs

RUN NODE_ARCH=$(uname -m | sed 's/^x86_64\|amd64$/x64/;s/^i.*86$/x86/;s/^aarch64$/arm64/') && \
    NODE_URL="https://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}-linux-${NODE_ARCH}.tar.gz" && \
    wget -O - "$NODE_URL" | tar -xz --strip-components=1 -C /usr/

COPY requirements.txt ./
RUN pip wheel -w wheel -r requirements.txt && \
    pip wheel -w wheel uwsgi

RUN pip wheel -w wheel psycopg2

WORKDIR /opt/warp/js/
COPY js/package.json js/package-lock.json ./
RUN npm install
COPY js/ ./
RUN npm run build

WORKDIR /opt/warp
COPY warp ./warp
COPY setup.py MANIFEST.in ./
RUN python setup.py bdist_wheel -d wheel

FROM python:3-slim
WORKDIR /opt/warp

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpcre3

COPY --from=compile-image /opt/warp/wheel ./wheel
RUN pip install --no-index ./wheel/*.whl

COPY --from=compile-image /opt/warp/warp/static ./static
COPY res/warp_uwsgi.ini .

EXPOSE 8000
ENTRYPOINT ["uwsgi", "warp_uwsgi.ini"]
