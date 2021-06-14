# website-monitoring-docker

Simple docker container that checks availability of websites.

Using gmail smtp server for email notifications. (For now, only gmail accounts are supported.)

The container will check the websites every hour by default. You can overwrite this behavior if you provide a file named _custom-cron_ and bind-mount it in the container in `/etc/cron.d`. See the docker-compose.yml example below. Here is the cron expression [documentation](https://docs.oracle.com/cd/E12058_01/doc/doc.1014/e12030/cron_expressions.htm) and a cron expression [generator](https://crontab.cronhub.io/).

You need to provide these environment variables:

### environment variables (case-sensitive!):
| Env variable | Description | Example |
| :------------- | :----------: | :----------- |
| `EMAIL_ADDRESS` | The email used to send the alert from and to. | `EMAIL_ADDRESS=youremail@gmail.com` |
| `EMAIL_PASSWORD` | Your email passwordused. It is recommended to generate an app password from your gmail account. | `EMAIL_PASSWORD=password` |
| `URLS` | URLs to be monitored. They are delimited by a comma. | `URLS=website.com,b.org,https://c.io` |
| `TZ` | Timezone. [Here is a list of possible values](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones "Wikipedia's list of timezones"). | `TZ=America/Toronto` |

docker-compose.yml example (this uses a .env file to store the env variables):
```
version: '3.6'
services:
  web-monitor:
    image: ghcr.io/iceoid/website-monitoring-docker
    container_name: web-monitor
    restart: unless-stopped
    environment:
      - TZ=America/Toronto
      - EMAIL_ADDRESS=$EMAIL_ADDRESS
      - EMAIL_PASSWORD=$EMAIL_PASSWORD
      # URLS are delimited by a comma i.e http://a.com,https://b.net,https://c.io
      - URLS=$URLS
    volumes:
      - ./custom-cron:/ect/cron.d/
```
