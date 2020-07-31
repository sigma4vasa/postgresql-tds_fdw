FROM docker.io/bitnami/postgresql:12-debian-10

LABEL maintainer="Gytis Tamulynas <Gytis@MPOServices.com>" \
    description="PostgreSQL, tds_fdw" \
    version="v1.0.0"

USER root

RUN apt-get update -y \
    && apt-get install libsybdb5 freetds-dev freetds-common gnupg gcc make wget -y \
    && export TDS_FDW_VERSION="2.0.1" \
    && wget https://github.com/tds-fdw/tds_fdw/archive/v${TDS_FDW_VERSION}.tar.gz \
    && tar -xvzf v${TDS_FDW_VERSION}.tar.gz \
    && cd tds_fdw-${TDS_FDW_VERSION}/ \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install \
    && cd .. \
    && rm v${TDS_FDW_VERSION}.tar.gz \
    && rm -rf tds_fdw-${TDS_FDW_VERSION} \
    && apt-get purge gnupg gcc make wget -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

USER 1001
