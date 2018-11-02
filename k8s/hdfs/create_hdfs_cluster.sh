#!/bin/bash

# Identify namenodes --overwrite hosts
kubectl label nodes --overwrite k8s-node06 my-hdfs-namenode-selector=hdfs-namenode
kubectl label nodes --overwrite k8s-node07 my-hdfs-namenode-selector=hdfs-namenode

# Identify non datanodes --overwrite hosts
kubectl label nodes --overwrite k8s-master1 my-hdfs-datanode-exclude=yes
kubectl label nodes --overwrite k8s-node04 my-hdfs-datanode-exclude=yes
kubectl label nodes --overwrite k8s-node05 my-hdfs-datanode-exclude=yes
kubectl label nodes --overwrite k8s-node06 my-hdfs-datanode-exclude=yes
kubectl label nodes --overwrite k8s-node07 my-hdfs-datanode-exclude=yes


# Create the HDFS cluster
helm install -n my-hdfs charts/hdfs-k8s  \
  --set hdfs-namenode-k8s.nodeSelector.my-hdfs-namenode-selector=hdfs-namenode \
  --set zookeeper.persistence.storageClass=managed-nfs-storage
