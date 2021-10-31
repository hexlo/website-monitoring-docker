```
  _____               _     _ 
  \_   \___ ___  ___ (_) __| |
   / /\/ __/ _ \/ _ \| |/ _` |
/\/ /_| (_|  __/ (_) | | (_| |
\____/ \___\___|\___/|_|\__,_|
                              
```
# website-monitoring-docker

### Simple docker container that checks availability of websites.

- Using gmail smtp server for email notifications by default.

- The container will check the websites every hour by default. You can overwrite this behavior if you provide a file named _custom-cron_ and bind-mount it in the container in `/etc/cron.d`. See the docker-compose.yml example below. Here is the cron expression [documentation](https://docs.oracle.com/cd/E12058_01/doc/doc.1014/e12030/cron_expressions.htm) and a cron expression [generator](https://crontab.cronhub.io/).

- Here are the environment variables to either provide or optionally modify:

### environment variables (case-sensitive!):
| Env variable | Description | Default | Example |
| :------------- | :----------: | :----------- | :----------- |
| `EMAIL_ADDRESS` *required* | The email used to send the alert from and to. | _none_ | `EMAIL_ADDRESS=youremail@gmail.com` |
| `EMAIL_PASSWORD` *required* | Your email passwordused. It is recommended to generate an app password from your gmail account. | _none_ | `EMAIL_PASSWORD=password` |
| `URLS` *required* | URLs to be monitored. They are delimited by a comma. | _none_ | `URLS=website.com,b.org,https://c.io` |
| `SMTP_SERVER` (_optional_) | smtp server address | `smtp.gmail.com` | `SMTP_SERVER=smtp.mail.yahoo.com` |
| `SMTP_PORT` (_optional_) | smtp port to be used. (25, SSL: 465, TLS: 587) | `465` | `SMTP_PORT=587` |
| `EMAIL_LIST` (_optional_) | Email list to send the alert to. | same value as `EMAIL_ADDRESS` | `EMAIL_LIST=joe@example.com,jane@domain.net` |
| `TZ` (_optional_) | Timezone. [Here is a list of possible values](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones "Wikipedia's list of timezones"). | `America/Toronto` | `TZ=America/Toronto` |

### `custom-cron` example (just modify the cron expression)
```
*/5 * * * * python3 monitor-websites.py
# This file must end with an empty or commented line
```

### `docker-compose.yml` example (this uses a .env file to store the env variables):
```
version: '3.6'
services:
  web-monitor:
    image: ghcr.io/iceoid/website-monitoring-docker
    container_name: web-monitor
    restart: unless-stopped
    environment:
      - EMAIL_ADDRESS=$EMAIL_ADDRESS
      - EMAIL_PASSWORD=$EMAIL_PASSWORD
      # URLS are delimited by a comma i.e a.com,http://b.net,https://c.io
      - URLS=$URLS
      - TZ=America/Toronto
    volumes:
      - ./scripts/custom-cron:/ect/cron.d/
```
