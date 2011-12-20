echo "" > addr.list
echo "select url from site;"|mysql dbname -uuser -ppasswd|while read line; do
  if echo "$line" | grep "excepted_url" > /dev/null ; then
    echo "" > /dev/null
  else
    domain=`echo "$line" | sed -e 's/\///'`
    echo "$domain"$'\t'  >> addr.list
    dig $domain|grep "$domain"|awk '{if(NF==5 && $1 eq "$domain") print $5}' >> addr.list
    echo $'\n'  >> addr.list
  fi
done
