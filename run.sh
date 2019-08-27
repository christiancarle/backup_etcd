#!/bin/sh

#ACTIVESTATE=`systemctl show etcd --property=ActiveState`
#SUBSTATE=`systemctl show etcd --property=SubState`
MINSIZE=45
DB_SIZE=`du -m /var/lib/etcd/member/snap/db | cut -f 1`

if [ "$ACTIVESTATE" = "ActiveState=active" ] && [ "$SUBSTATE" = "SubState=running" ] && [ $MINSIZE -le $DB_SIZE ] && grep -qs '/nas_etcd' /proc/mounts
then
  mkdir -p /nas_etcd/etcd_backup/`hostname -s`/etcd-config-$(date +%Y%m%d)/
  cp -R /etc/etcd/ /nas_etcd/etcd_backup/`hostname -s`/etcd-config-$(date +%Y%m%d)/
  mkdir -p /nas_etcd/etcd_backup/`hostname -s`/etcd-data-$(date +%Y%m%d)
  /tmp/etcd/etcdctl --cert="/etc/etcd/peer.crt" --key="/etc/etcd/peer.key" --cacert="/etc/etcd/ca.crt"  --endpoints https://`hostname`:2379 snapshot save /nas_etcd/etcd_backup/`hostname -s`/etcd-data-$(date +%Y%m%d)/db
else
  curl -X POST 'http://gotsva1240.got.volvocars.net:9093/api/v1/alerts' -d '[{"labels":{"alertname":"EtcdBackupFail","cluster":"Bravo","instance":"'"`hostname`"'","severity":"warning"}}],"receivers":["masp-test"]'
