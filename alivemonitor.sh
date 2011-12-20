MDATE=`date +%Y%m%d`

# RAID 状態 ###################################################################
/usr/local/bin/tw_cli info c0 > /home/admin/raid_status/${MDATE}
chmod 666 /home/admin/raid_status/${MDATE}

# 不正アクセスIPアドレスを拒否設定に追加する
cat /var/log/secure|grep "Invalid user"|awk '{print $NF}' FS=":"|uniq|while read line; do
  if [ `grep -c $line /etc/hosts.deny` == 0 ]; then
    echo "all: $line" >> /etc/hosts.deny
  fi
done

# 負荷 ########################################################################
if [ `free|awk '{if((NR==2 && $4<1000) || (NR==4 && $4<8000)) print $4}'|wc -l` != 0 ]; then
  free|mail alert@example.com -s 'WARNING - Main-memory is almost full'
fi

# MySQL #######################################################################
mystat=`mysqladmin ping -uuser -ppasswd`

if [ "'${mystat}'" ne "'mysqld is alive'" ]; then
  echo ${mystat}|mail alert@example.com -s 'WARNING - MySQL is not alive'
fi

slaveio=`echo 'show slave status\G' | mysql -uuser -ppasswd | grep 'Slave_IO_Running' | awk '{print $NF}' FS=':' | sed 's/ //'`
slavesql=`echo 'show slave status\G' | mysql -uuser -ppasswd | grep 'Slave_SQL_Running' | awk '{print $NF}' FS=':' | sed 's/ //'`
if [ "'${slaveio}'" ne "'Yes'" ] || [ "'${slavesql}'" ne "'Yes'" ]; then
  mail alert@example.com -s 'WARNING - MySQL Slave is not running'
fi

# Apache ######################################################################
RESULTCODE=`wget -S --spider -nv http://example.com 2>&1|grep -c "200 OK"`
if [ $RESULTCODE != 1 ]; then
  mail alert@example.com -s 'WARNING - HTTPD is not alive'
fi

