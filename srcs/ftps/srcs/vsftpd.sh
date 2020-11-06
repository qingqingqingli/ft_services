#!/bin/sh

# change the conf value based on yaml input
echo "pasv_max_port=$PASV_MAX" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=$PASV_MIN" >> /etc/vsftpd/vsftpd.conf
echo "pasv_address=$PASV_ADDRESS" >> /etc/vsftpd/vsftpd.conf

# create FTP users
addgroup -g 433 -S $FTP_USER
adduser -u 431 -D -G $FTP_USER -h /home/$FTP_USER -s /bin/false  $FTP_USER

# set password & give access
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd
chown $FTP_USER:$FTP_USER /home/$FTP_USER/ -R

# start the service
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf