# FROM mcr.microsoft.com/azure-cli
FROM ubuntu:20.04
RUN : \
 && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3.8-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN python3.8 -m venv /venv
ENV PATH=/venv/bin:$PATH

RUN pip install --no-cache-dir dbt-snowflake==1.5.1
COPY ./*.sh /
RUN chmod 755 /*.sh

ADD dbt_on_container /mnt/github/dbt_on_container

ENTRYPOINT [ "/entrypoint.sh" ] 
# CMD ./entrypoint.sh