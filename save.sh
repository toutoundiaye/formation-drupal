#!/usr/bin/env sh

TMP_DIR=../backup_tmp
mkdir -p ${TMP_DIR}

DEST_DIR=../backups
mkdir -p ${DEST_DIR}

# Put site in maintenance mode for safety
drush state:set site.maintenance_mode TRUE

drush sql:dump > ${TMP_DIR}/database-backup.sql
rsync --exclude=".git/" --exclude="vendor/" ./ ${TMP_DIR}

#Archive everything (file & data)
tar -czf ${DEST_DIR}/backup_$(date -Is).tgz ${TMP_DIR}/

# Put site online
drush state:set site.maintenance_mode FALSE

#clean tmp directory
chmod -R u+w ${TMP_DIR}
rm -rf ${TMP_DIR}