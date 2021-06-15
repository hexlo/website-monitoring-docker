FROM python:3.9-slim-buster

ENV TZ=America/Toronto

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e

RUN apt-get update && apt-get -y install cron tzdata

RUN pip install requests

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    touch /var/log/cron.log

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

WORKDIR /usr/local/bin

COPY ./scripts/custom-cron /etc/cron.d/

COPY ./scripts/monitor-websites.py .

RUN chmod +x monitor-websites.py

VOLUME ["/etc/cron.d/"]

CMD ["supercronic", "/etc/cron.d/custom-cron"]
