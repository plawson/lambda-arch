# Spark
The [Spark](https://spark.apache.org/) is 2.4.0. The binaries should be installed on the boxes sued to submit the jobs.

## Installation

In the below procedure, replace <user> and <host> with the values that suit your environment.
```console
$ cd lambda-arch/configuration
$ scp -r spark-conf <user>@<host>:/home/<user>
$ ssh <user>@<host>
$ cd cd spark-conf
$ ./setup-spark.sh
