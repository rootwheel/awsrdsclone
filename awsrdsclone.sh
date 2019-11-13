#!/bin/bash

DEVCLUSTER=companydev-cluster
DEVDB=companydevdb
LOGFILE=rdsclone.log

function log ()
               	{
                echo "[$(date --rfc-3339=seconds)]: $*"
                }
function dbprobe () 
                {
                aws rds describe-db-instances --db-instance-identifier $DEVDB --query 'DBInstances[*].[DBInstanceStatus]' --output text 2>>$LOGFILE
                }
function clusterClone ()
                {
                aws rds restore-db-cluster-to-point-in-time --source-db-cluster-identifier hrmdb-cluster --db-cluster-identifier hrmdbdev-cluster --restore-type copy-on-write --use-latest-restorable-time --db-subnet-group-name default-$
                log Cluster cloning >> $LOGFILE
                }
function dbCreate ()
                {
                aws rds create-db-instance --db-cluster-identifier $DEVCLUSTER --db-instance-class db.t3.small --engine aurora --db-instance-identifier $DEVDB --publicly-accessible --db-subnet-group-name default-vpc-eff7b486 2>>$LOGFILE
                log DB creation >> $LOGFILE
                }
function dbDelete ()
                {
                aws rds delete-db-instance --db-instance-identifier $DEVDB 2>>$LOGFILE
                log Deleting expired DB >> $LOGFILE
                }
function clusterDelete ()
                {
                aws rds delete-db-cluster --db-cluster-identifier $DEVCLUSTER --skip-final-snapshot 2>>$LOGFILE

                log Deleting expired Cluster >> $LOGFILE
                }

log Rotation started >> $LOGFILE
if [[ $(dbprobe)  != available ]]
	then clusterClone ; sleep 8m ; dbCreate
	else dbDelete ; sleep 5m ; clusterDelete ; sleep 3m ; clusterClone ; sleep 8m ; dbCreate
fi