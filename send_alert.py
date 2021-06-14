#!/usr/bin/env python

import smtplib
import requests
import os
from email.message import EmailMessage

urls = os.getenv('URLS').split(',')
if not urls:
    print("No urls provided. Exiting.", file=sys.stderr) 
    return 1

emailAddress = os.getenv('EMAIL_ADDRESS')
password = os.getenv('EMAIL_PASSWORD')
if not emailAddress or not password:
    print("Email address and password must be defined. Exiting.", file=sys.stderr) 
    return 1
#password = "csfgymkwhhpwumpz"

msg = EmailMessage()
msg['From'] = emailAddress
msg['To'] = emailAddress


# Function to send the message via our own SMTP server.
def sendAlert(message):
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.login(emailAddress, password)
    server.send_message(message)
    server.quit()

for url in urls:
    r = requests.get(url)
    if (r.status_code != 200):
        msg.set_content('Your webserver: ' + url + ' might be down.')
        msg['Subject'] = '[web-monitoring]: ' + url

        if __name__ == '__main__':
            sendAlert(msg)


