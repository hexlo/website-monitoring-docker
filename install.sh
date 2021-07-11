#!/bin/bash


touch .env
echo > .env
echo "Created .env file."

echo "Configuring variables for Website-monitoring."
read -rp "Enter the email address to send alerts to." email
echo "EMAIL_ADDRESS=${email}" >> .env
read -rp "Enter the email password to use. You should use a generated app password instead of the global one." passwd
echo "EMAIL_PASSWORD=${passwd}" >> .env
read -rp "Enter comma-delimited URLS. (i.e: https://a.com,b.net,http://c.org)" urls
echo "URLS=${urls}" >> .env
