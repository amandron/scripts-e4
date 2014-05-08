#/bin/bash

lvcreate -L 150M -s -n snap_site /dev/mapper/lvmgroup-gf_gsb
mount /dev/mapper/lvmgroup-snap_site /var/www/gf-gsb/
mysqldump -uroot -proot --databases bdapplifrais > bdapplifrais.sql
mv bdapplifrais.sql /var/www/gf-gsb/
tar -zcvf /backups/site_$(date +%d-%m-%Y-%H-%M).tar.gz /var/www/gf-gsb/*
umount /dev/mapper/lvmgroup-snap_site /var/www/gf-gsb/
lvremove -f /dev/mapper/lvmgroup-snap_site
