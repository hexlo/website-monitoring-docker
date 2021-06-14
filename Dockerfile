FROM python:3.9.5

ENV TZ=America/Toronto

RUN apt-get update && apt-get -y install cron tzdata

RUN pip install requests

RUN touch /etc/cron.d/website-monitoring-cron /var/log/cron.log && \
    chmod 0644 /etc/cron.d/website-monitoring-cron && \
    echo "0 */4 * * * python3 /usr/local/bin/send_alert.py >> /var/log/cron.log 2>&1" > /etc/cron.d/website-monitoring-cron && \
    echo "" >> /etc/cron.d/website-monitoring-cron && \
    crontab /etc/cron.d/website-monitoring-cron && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


WORKDIR /usr/local/bin

COPY ./send_alert.py .

RUN chmod +x send_alert.py

CMD tail -f /dev/null
