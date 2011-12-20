# cronなどで定期的に実行させる。
if [ $(ps -ef|grep rsync|grep 123.123.123.123|wc -l) == 0 ]; then
  /usr/bin/rsync -az --delete --exclude-from /home/admin/exclude_pattern -e 'ssh -i /home/admin/.ssh/b2' /var/www/html/* 123.123.123.123:/var/www/html/
fi


#転送したくないファイルは、「exclude_pattern」というファイルにリストアップしておく。
#cat /home/admin/exclude_pattern
#config.ini
#templates_c/
