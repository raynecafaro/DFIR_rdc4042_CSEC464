echo "###System Time###"
date | cut -d' ' -f5
echo

echo "###TIMEZONE###"
date | awk -F ' ' '{print $5}'
echo

echo "###UPTIME###"
uptime | awk -F ',' '{print $1}' | cut -d ' ' -f 3-
echo

echo "####OS INFO###"
uname -a
echo

echo "###CPUINFO###"
cat /proc/cpuinfo | grep "model name"
echo

echo "###TOTAL RAM###"
cat /proc/meminfo | grep MemTotal
echo

echo "###HDDINFO###"
lsblk
echo

echo "###HOSTNAME###"
hostname
echo

echo "###DOMAINNAME###"
domainname
echo

echo "###USERS###"
for i in $( awk -F ':' '{print $1}' /etc/passwd ); do
	id $i
done
echo

echo "###USER LOGIN INFO###"
cat /var/log/auth.log | grep "pam" || lastlog
echo

echo "###SERVICES ON BOOT###"
systemctl list-unit-files --type=service | grep -i enable
echo

echo "###SCHEDULED TASKS###"
crontab -l
echo

echo "###ARP TABLE###"
arp -a || echo "ARP package doesn't exist for some reason"
echo

echo "###NETWORK INFO###"
network=$(ip a || ifconfig)
echo

echo "###DHCP INFO###"
echo "DCHP INFO"
echo

echo "###DNS INFO###"
cat /etc/resolv.conf
echo

echo "###LISTENING SERVICES###"
netstat -ptunl
echo 

echo "###ESTABLISHED CONNECTIONS"""
netstat -optuna | grep EST
echo

echo "###INSTALLED SOFTWARE###"
ls /bin && ls /sbin && ls /usr/bin && ls /usr/sbin
echo

echo "###PROCESS LIST###"
ps -aux
echo

echo "###PARENT PROCESS LIST###"
ps -axj
echo

echo "###LOADED KERNEL MODULES###"
lsmod
echo

echo "###ALL USER DOCUMENTS###"
ls /home/*/Downloads && ls /home/*/Documents && ls /root/*
echo

echo "###LISTENING RAW SOCKETS###"
lsof | grep -Ei "raw|pcap"
echo

echo "###FILES TOUCHED IN LAST 5 MINUTES###"
find / -xdev -cmin -5 2> /dev/null
echo

echo "###MOUNTED FILESYSTEMS###"
mount
echo

