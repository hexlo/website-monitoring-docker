#!/usr/bin/env python

import smtplib
import requests
import os
from email.message import EmailMessage

def main():

    urls = os.getenv('URLS').split(',')

    emailAddress = os.getenv('EMAIL_ADDRESS')
    password = os.getenv('EMAIL_PASSWORD')
    if not emailAddress or emailAddress == "" or not password or password == "":
        print("Email address and password must be defined. Exiting.")
        return 1




    # Function to send the message via our own SMTP server.
    def sendAlert(message):
        server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        server.login(emailAddress, password)
        server.send_message(message)
        server.quit()

    for url in urls:
        print(url)
        try:
            r = requests.get(url)
            print(r.status_code)
            if not r.status_code in {200, 301, 302, 308}:
                msg = EmailMessage()
                msg['From'] = emailAddress
                msg['To'] = emailAddress
                msg.set_content('Your webserver: ' + url + ' might be down. \n Received error code: ' + str(r.status_code))
                msg['Subject'] = '[web-monitoring]: ' + url
                sendAlert(msg)
        except:
            r.status_code = "Connection Refused"
            print("Bad URL. Cannot proceed.")


if __name__ == '__main__':
    main()
