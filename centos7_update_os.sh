#!/bin/bash

echo "Securing root Logins"
echo "tty1" > /etc/securetty
chmod 700 /root

echo "DISABLE FIREWALL, POSTFIX"
systemctl disable firewalld
systemctl disable postfix

#echo "Deny All TCP Wrappers"
#echo "ALL:ALL" >> /etc/hosts.deny
#echo "sshd:ALL" >> /etc/hosts.allow

echo "EDIT SYSCTL"
echo "fs.file-max = 4587520" >>/etc/sysctl.conf
echo "net.core.somaxconn= 2048" >>/etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >>/etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >>/etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >>/etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >>/etc/sysctl.conf
echo "vm.swappiness=0" >>/etc/sysctl.conf
echo "vm.overcommit_memory=1" >>/etc/sysctl.conf
sysctl -p

#echo "DISABLE IPV6"
#echo "options ipv6 disable=1" >>/etc/modprobe.d/disabled.conf
#echo "NETWORKING_IPV6=no" >>/etc/modprobe.d/disabled.conf
#echo "IPV6INIT=no" >>/etc/modprobe.d/disabled.conf

echo "EDIT LIMITS.CONF"
echo "* hard core 0" >>/etc/security/limits.conf
echo "root soft nofile 32768" >>/etc/security/limits.conf
echo "root soft nproc 65536" >>/etc/security/limits.conf
echo "root hard nofile 1048576" >>/etc/security/limits.conf
echo "root hard nproc unlimited" >>/etc/security/limits.conf
echo "root - memlock unlimited" >>/etc/security/limits.conf

# echo "ENABLE HUGEPAGE"
# echo "if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
# echo never > /sys/kernel/mm/transparent_hugepage/enabled
# fi" >> /etc/rc.d/rc.local

# echo "if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
# echo never > /sys/kernel/mm/transparent_hugepage/defrag
# fi" >>/etc/rc.d/rc.local

echo "INSTALL EPEL-RELEASE"
yum install epel-release -y
yum install  iptables-services net-tools htop glances tuned chrony wget -y
yum groupinstall "Development Tools" -y

echo "INSTALL Rsyslog"
yum -y install rsyslog
systemctl enable rsyslog.service
systemctl start rsyslog.service

echo "SET TIMEZONE"
timedatectl set-timezone Asia/Ho_Chi_Minh

systemctl enable iptables chronyd crond tuned
systemctl start chronyd
chronyc tracking

echo "Update kernel"
yum update kernel -y

# echo "IF RUN TUNED ==> "
# echo "tuned-adm profile throughput-performance"

echo "EDIT SELINUX"
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

#cmdlog
echo "export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug \"[\$(echo \$SSH_CLIENT | cut -d\" \" -f1)] # \$(history 1 | sed \"s/^[ ]*[0-9]\+[ ]*//\" )\"'" >>/etc/bashrc
echo "local6.debug                /var/log/cmdlog.log" >> /etc/rsyslog.conf
>/var/log/cmdlog.log
service rsyslog restart
echo "/var/log/cmdlog.log {
  create 0644 root root
  compress
  weekly
  rotate 12
  sharedscripts
  postrotate
  /bin/kill -HUP \`cat /var/run/syslogd.pid 2> /dev/null\` 2> /dev/null || true
  endscript
}" >>/etc/logrotate.d/cmdlog
