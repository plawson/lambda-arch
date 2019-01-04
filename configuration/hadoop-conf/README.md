# Hadoop Cluster
[Hadoop](http://hadoop.apache.org/) cluster running [HDFS](http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html) and [YARN](http://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/YARN.html). It's used to host a data lake and act as a resource negociator for [Spark](https://spark.apache.org/) programs.
This is a prototype cluster with no HA and no security configuration.

| Role                    | Host     | Alias              | CPU# | Memory | Disk |
|:------------------------|:---------|:-------------------|-----:|-------:|-----:|
|Namenode/Resource manager|k8s-node05|namenode/resourcemgr| 2    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node06|datanode1/nodemgr1  | 4    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node07|datanode2/nodemgr2  | 4    | 15Gb   | 2Tb  |
|Datanode/Node manager    |k8s-node08|datanode3/nodemgr3  | 4    | 15Gb   | 2Tb  |

## Datanode1 and Nodemanager1
```console
$ cd lambda-arch/configuration/hadoop-conf
$ scp -r slaves ubuntu@k8s-node06:/home/ubuntu
$ ssh ubuntu@k8s-node06
$ cd slaves
$ ./setup-slave.sh
```

## Datanode2 and Nodemanager2
```console
$ cd lambda-arch/configuration/hadoop-conf
$ scp -r slaves ubuntu@k8s-node07:/home/ubuntu
$ ssh ubuntu@k8s-node07
$ cd slaves
$ ./setup-slave.sh
```

## Datanode3 and Nodemanager3
```console
$ cd lambda-arch/configuration/hadoop-conf
$ scp -r slaves ubuntu@k8s-node08:/home/ubuntu
$ ssh ubuntu@k8s-node08
$ cd slaves
$ ./setup-slave.sh
```

## Namenode and Resource manager
```console
$ cd lambda-arch/configuration/hadoop-conf
$ scp -r master ubuntu@k8s-node05:/home/ubuntu
$ ssh ubuntu@k8s-node05
$ ssh-keygen
$ ssh-copy-id ubuntu@k8s-node05
$ ssh-copy-id ubuntu@k8s-node06
$ ssh-copy-id ubuntu@k8s-node07
$ ssh-copy-id ubuntu@k8s-node08
$ cd master
$ ./setup-master.sh
```
