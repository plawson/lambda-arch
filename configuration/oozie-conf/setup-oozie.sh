#!/bin/bash -e

SCRIPT=$(realpath $0)
SETUP_DIR=$(dirname $SCRIPT)
UBUNTU_DIR=/home/ubuntu
INSTALL_DIR=${UBUNTU_DIR}/oozie
HADOOP_DIR=${UBUNTU_DIR}/hadoop


echo "Downloading Oozie distribution..."
cd ${UBUNTU_DIR}
wget https://www-eu.apache.org/dist/oozie/5.1.0/oozie-5.1.0.tar.gz
tar xf oozie-5.1.0.tar.gz
rm oozie-5.1.0.tar.gz
mv oozie-5.1.0 oozie-5.1.0-main
sudo apt install -y maven
sudo apt-get install -y default-jdk
sudo apt install -y unzip
sudo apt install -y zip
cd oozie-5.1.0-main/bin
./mkdistro.sh -DskipTests -P spark-2
cp -r ../distro/target/oozie-5.1.0-distro/oozie-5.1.0 ${UBUNTU_DIR}
cd ${UBUNTU_DIR}
ln -s oozie-5.1.0 oozie
cd ${UBUNTU_DIR}/oozie
mkdir libext
cd libext
wget http://central.maven.org/maven2/com/extjs/gxt/2.3.1-gwt22/gxt-2.3.1-gwt22.jar
wget http://archive.cloudera.com/gplextras/misc/ext-2.2.zip
cd ${INSTALL_DIR}
tar xf oozie-client-5.1.0.tar.gz
tar xf oozie-examples.tar.gz
tar xf oozie-sharelib-5.1.0.tar.gz
cp ${HADOOP_DIR}/share/hadoop/common/*.jar ${INSTALL_DIR}/libext
cp ${HADOOP_DIR}/share/hadoop/common/lib/*.jar ${INSTALL_DIR}/libext
cp ${HADOOP_DIR}/share/hadoop/hdfs/*.jar ${INSTALL_DIR}/libext
cp ${HADOOP_DIR}/share/hadoop/hdfs/lib/*.jar ${INSTALL_DIR}/libext
cp ${HADOOP_DIR}/share/mapreduce/hdfs/*.jar ${INSTALL_DIR}/libext
cp ${HADOOP_DIR}/share/mapreduce/hdfs/lib/*.jar ${INSTALL_DIR}/libext
cp ${HADOOP_DIR}/share/mapreduce/yarn/*.jar ${INSTALL_DIR}/libext
cp ${HADOOP_DIR}/share/mapreduce/yarn/lib/*.jar ${INSTALL_DIR}/libext

echo "Configuring Oozie..."
mv ${INSTALL_DIR}/conf/hadoop-conf/core-site.xml ${INSTALL_DIR}/conf/hadoop-conf/core-site.xml.orig
cp ${SETUP_DIR}/core-site.xml ${INSTALL_DIR}/conf/hadoop-conf
mv ${INSTALL_DIR}/conf/oozie-default.xml ${INSTALL_DIR}/conf/oozie-default.xml.orig
cp ${SETUP_DIR}/oozie-default.xml ${INSTALL_DIR}/conf
cd ${INSTALL_DIR}/bin
mkdir ${INSTALL_DIR}/oozie_war_dir
./addtowar.sh -inputwar ${UBUNTU_DIR}/oozie-5.1.0-main/webapp/target/oozie-webapp-5.1.0.war -outputwar ${INSTALL_DIR}/oozie_war_dir/oozie.war -hadoop 2.9 ${HADOOP_DIR} -extjs ${INSTALL_DIR}/ubuntu/oozie/libext/ext-2.2.zip
cp ${INSTALL_DIR}/oozie_war_dir/oozie.war ${INSTALL_DIR}
./oozie-setup.sh sharelib create -fs hdfs://k8s-node05:9000
