# Oozie
[Oozie](http://oozie.apache.org/) is an Apache top level project. It's a workflow scheduler system to manage Apache Hadoop jobs. The batch layer is an Oozie first class citizen. The layer is to be ran at least once a day, then the sped layer views need to be switched as stated by the Lambda Architecture best pratices. These two actions will be configured as a workflow with a Saprk Action followed by a Java Action.

## Installation
```console
$ cd lambda-arch/configuration
$ scp -r oozie-conf ubuntu@k8s-nodeO5:/home/ubuntu
$ ssh ubuntu@k8s-node05
$ cd oozie-conf
$ ./setup-oozie.sh
```
