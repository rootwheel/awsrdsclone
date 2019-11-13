#!/bin/bash

PS3='Please enter your choice: '
options=("Describe clusters" "Describe instances" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Describe clusters")
                aws rds describe-db-clusters --query 'DBClusters[*].{Cluster_ID:DBClusterIdentifier,Endpoint:Endpoint,Status:Status}'  --output table
            ;;
	"Describe instances")
                aws rds describe-db-instances --query 'DBInstances[*].{Cluster_ID:DBClusterIdentifier,Class:DBInstanceClass,Instance_ID:DBInstanceIdentifier,Status:DBInstanceStatus,Creation_time:InstanceCreateTime,Address:Endpoint.Addr$
            ;;
	"Quit")
            break
            ;;
	*) echo "invalid option $REPLY";;
    esac
done
