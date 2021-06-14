FROM python:3.9.5

ENV TZ=America/Toronto

ENV CRON_EXPRESSION="0 * * * *"

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

RUN apt-get update && apt-get -y install cron tzdata

RUN pip install requests

RUN touch /etc/cron.d/website-monitoring-cron /var/log/cron.log && \
    chmod 0644 /etc/cron.d/website-monitoring-cron && \
    echo '${CRON_EXPRESSION} python3 /usr/local/bin/send_alert.py >> /var/log/cron.log 2>&1' > /etc/cron.d/website-monitoring-cron && \
    echo "# Empty line." >> /etc/cron.d/website-monitoring-cron && \
#    crontab /etc/cron.d/website-monitoring-cron && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


WORKDIR /usr/local/bin

COPY ./send_alert.py .

RUN chmod +x send_alert.py

CMD ["supercronic", "/etc/cron.d/website-monitoring-cron"]
# CMD tail -f /dev/null
