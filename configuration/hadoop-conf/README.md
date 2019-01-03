# Hadoop Cluster
[Hadoop](http://hadoop.apache.org/) cluster running [HDFS](http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html) and [YARN](http://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/YARN.html). It's used to host a data lake and act as a resource negociator for [Spark](https://spark.apache.org/) programs.
This is a prototype cluster with no HA and no security configuration.

| Role                    | Host     | Alias              | CPU# | Memory | Disk |
|:------------------------|:---------|:-------------------|-----:|-------:|-----:|
|Namenode/Resource manager|k8s-node05|namenode/resourcemgr| 2    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node06|datanode1/nodemgr1  | 4    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node07|datanode2/nodemgr2  | 4    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node08|datanode3/nodemgr3  | 4    | 15Gb   | 2Tb  |

## Namenode and Resource manager
These instances are installed on the smae node for this prototype.

Package download:
```console
$ cd lambda-arch/configuration
$ scp -r hadoop-conf ubuntu@k8s-node05:/home/ubuntu
$ ssh ubuntu@k8s-node05
$ cd hadoop-conf
$ ./setup-hadoop.sh
```
