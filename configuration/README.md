# Clusters Setup
This is a prototype environment base on single and multi nodes clusters. The nodes are VirtualBoxes VMs managed with the customization scripts found in [this repo](https://github.com/plawson/vm-mgmt).

## Nodes description
The VMs are created on a bare-metal (2 NIC) server with two 12 core CPU, 256Gb of memory and a 2Tb SSD internal disk. The VM disks are located on a Synology 3615xs (4 NIC) with huit 8Tb disk in a RAID 6 volume group (39Tb space) mounted using ISCSI via DM-Multipath. The ISCSI target is configured with multi session so that all I/O are load balanced across the 6 NICs. All NICs are connected to a high speed Netgear switch.

| Role                    | Host     | Alias              | CPU# | Memory | Disk |
|:------------------------|:---------|:-------------------|-----:|-------:|-----:|
|Schema Registry          |k8s-node01|schema              | 1    | 15Gb   | 2Tb  |
|Kafka Connect            |k8s-node02|connect             | 1    | 15Gb   | 2Tb  |
|[Zookeeper](https://github.com/plawson/lambda-arch/tree/master/configuration/zookeeper-conf)                |k8s-node03|zookeeper           | 2    | 15Gb   | 2Tb  |
|[Kafka](https://github.com/plawson/lambda-arch/tree/master/configuration/kafka-conf)                    |k8s-node04|kafka               | 2    | 15Gb   | 2Tb  |
|Namenode/Resource manager|k8s-node05|namenode/resourcemgr| 2    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node06|datanode1/nodemgr1  | 4    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node07|datanode2/nodemgr2  | 4    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node08|datanode3/nodemgr3  | 4    | 15Gb   | 2Tb  |
|Cassandra                |k8s-node09|cassandra           | 2    | 15Gb   | 2Tb  |
|UI node                  |k8s-node10|uinode              | 1    | 15Gb   | 2Tb  |
