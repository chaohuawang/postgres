FROM postgres:17.7

ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    apt-get install -y postgresql-17-cron && \
    apt-get clean && \
    echo "${TZ}" | tee /etc/timezone && \
    rm -rf /var/lib/apt/lists/*

ENV LC_TIME=C.UTF-8
