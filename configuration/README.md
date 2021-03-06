# Clusters Setup
This is a prototype environment based on single and multi nodes clusters. The nodes are VirtualBox VMs managed with my ISO and VM customization scripts found in the [vm-mgmt](https://github.com/plawson/vm-mgmt) repo.

## Nodes description
The VMs are created on a bare-metal (2 NIC) server with two 12 core CPUs, 256Gb of memory and a 2Tb SSD internal drive. The VM disks are located on a NAS (4 NIC) with eight 8Tb disks in a RAID 6 volume group (39Tb space) mounted using ISCSI via DM-Multipath. The ISCSI LUN is configured with multi session enabled so that all I/O are load balanced across the 6 NICs. All 6 NICs are connected to a high speed Netgear switch.

| Role                    | Host     | Alias              | CPU# | Memory | Disk |
|:------------------------|:---------|:-------------------|-----:|-------:|-----:|
|[Schema Registry](https://github.com/plawson/lambda-arch/tree/master/configuration/schema-registry-conf)          |k8s-node01|schema              | 1    | 15Gb   | 2Tb  |
|[Kafka Connect](https://github.com/plawson/lambda-arch/tree/master/configuration/kafka-connect-conf)            |k8s-node02|connect             | 1    | 15Gb   | 2Tb  |
|[Zookeeper](https://github.com/plawson/lambda-arch/tree/master/configuration/zookeeper-conf)                |k8s-node03|zookeeper           | 2    | 15Gb   | 2Tb  |
|[Kafka](https://github.com/plawson/lambda-arch/tree/master/configuration/kafka-conf)                    |k8s-node04|kafka               | 2    | 15Gb   | 2Tb  |
|[Namenode/Resource manager](https://github.com/plawson/lambda-arch/blob/master/configuration/hadoop-conf/README.md#namenode-and-resource-manager)|k8s-node05|namenode/resourcemgr| 2    | 15Gb   | 2Tb  |
|[Datanode/Node manager](https://github.com/plawson/lambda-arch/blob/master/configuration/hadoop-conf/README.md#datanode1-and-nodemanager1)    |k8s-node06|datanode1/nodemgr1  | 4    | 15Gb   | 2Tb  |
|[Datanode/Node manager](https://github.com/plawson/lambda-arch/blob/master/configuration/hadoop-conf/README.md#datanode2-and-nodemanager2)    |k8s-node07|datanode2/nodemgr2  | 4    | 15Gb   | 2Tb  |
|[Datanode/Node manager](https://github.com/plawson/lambda-arch/blob/master/configuration/hadoop-conf/README.md#datanode3-and-nodemanager3)    |k8s-node08|datanode3/nodemgr3  | 4    | 15Gb   | 2Tb  |
|[Cassandra](https://github.com/plawson/lambda-arch/blob/master/configuration/cassandra-conf)                |k8s-node09|cassandra           | 2    | 15Gb   | 2Tb  |
|[UI node](https://github.com/plawson/lambda-arch/tree/master/configuration/ui-conf)                  |k8s-node10|uinode              | 1    | 15Gb   | 2Tb  |

## Spark
Spark is to be configured on client machines used to start the jobs. The configuration procedure is available [here](https://github.com/plawson/lambda-arch/tree/master/configuration/spark-conf)
