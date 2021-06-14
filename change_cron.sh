#!/bin/bash
touch change_cron.sh
chmod +x change_cron.sh
echo > change_cron.sh
echo "#!/bin/bash" >> change_cron.sh
echo "if [ ! -z \"\${CRON_EXPRESSION}\" ]; then" >> change_cron.sh
echo "  echo > /etc/cron.d/website-monitoring-cron" >> change_cron.sh
echo "  echo \""${CRON_EXPRESSION} python3 /usr/local/bin/send_alert.py"\" > /etc/cron.d/website-monitoring-cron" >> change_cron.sh
echo "  echo "#Empty line." >> /etc/cron.d/website-monitoring-cron" >> change_cron.sh
echo "fi" >> change_cron.sh