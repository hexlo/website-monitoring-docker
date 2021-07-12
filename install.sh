#!/bin/bash

echo "### Install script for Website-monitoring ###"
echo ""
read -rp "Would you like initialise the sensitive files? [y/N] " initResponse
if [[ "${initResponse}" =~ ^([yY]|[yY][eE][sS])$ ]]; then
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
fi
echo "Done!"
echo ""
