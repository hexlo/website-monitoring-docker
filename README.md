# website-monitoring-docker

Simple docker container that checks availability of websites.

Using gmail smtp server. (For now, only gmail accounts are supported.)

You need to provide those 3 environment variables:

### environment variables (case-sensitive!):
| Env variable | Description | Example |
| :------------- | :----------: | :----------- |
| `EMAIL_ADDRESS` | The email used to send the alert from and to | `EMAIL_ADDRESS=youremail@gmail.com` |
| `EMAIL_PASSWORD` | Your email passwordused. It is recommended to generate an app password from your gmail account | `EMAIL_PASSWORD=password` |
| `URLS` | URLs to be monitored. They are delimited by a comma. | `URLS=website.com,b.org,https://c.io` |

