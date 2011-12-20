# 不正アクセスIPアドレスを拒否設定に追加する
cat /var/log/secure|grep "Invalid user"|awk '{print $NF}' FS=":"|uniq|while read line; do
  if [ `grep -c $line /etc/hosts.deny` == 0 ]; then
    echo "all: $line" >> /etc/hosts.deny
  fi
done
