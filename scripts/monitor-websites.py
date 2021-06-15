#!/usr/bin/env python

from email.message import EmailMessage
import os
import re
import requests
import smtplib

# Takes a list of urls and makes sure they start with either http:// or https://
def fix_URLS(urls):
    fixed_urls = []
    for url in urls:
        if not re.search('^(https?://)', url):
            string = "http://"
            string += url
            fixed_urls.append(string)
        else:
            fixed_urls.append(url)
    return fixed_urls

# Takes a website url to monitor, a from and to emails and creates an email msg body
def create_msg(url, from_email, to_emails=None):
    if to_emails is None:
        to_emails = from_email
    try:
        r = requests.get(url)
        print(url)
        print(r.status_code)
        if not r.status_code in {200, 301, 302, 308}:
            msg = EmailMessage()
            msg['From'] = from_email
            msg['To'] = to_emails
            msg.set_content('Your webserver: ' + url + ' might be down. \n Received error code: ' + str(r.status_code))
            msg['Subject'] = '[web-monitoring]: ' + url
            return msg
    except:
        r.status_code = "Connection Refused"
        return 1

# Function to send the message via our own SMTP server.
def send_alert(message, email, passwd, smtp_server="smtp.gmail.com", port=465):
    server = smtplib.SMTP_SSL(smtp_server, port)
    server.login(email, passwd)
    server.send_message(message)
    server.quit()

def main():

    urls_env_var = os.getenv('URLS')
    if urls_env_var:
        urls = urls_env_var.split(',')
    else:
        print("No URLs provided. Exiting")
        return 1
    
    fixed_urls = fix_URLS(urls)

    email_address = os.getenv('EMAIL_ADDRESS')
    password = os.getenv('EMAIL_PASSWORD')
    if not email_address or email_address == "" or not password or password == "":
        print("Email address and password must be defined. Exiting.")
        return 1
    
    smtp = os.getenv('SMTP_SERVER')
    if smtp is None:
        smtp = "smtp.gmail.com"
    
    smtp_port = os.getenv('SMTP_PORT')
    if smtp_port is None:
        smtp_port = 465

    
    email_list_env_var = os.getenv('EMAIL_LIST')
    if email_list_env_var:
        email_list = email_list_env_var.split(',')
    else:
        email_list = email_address

    for url in fixed_urls:
        message = create_msg(url, email_address, email_list)
        if message is not None:
            send_alert(message, email_address, password, smtp, smtp_port)

if __name__ == '__main__':
    main()
