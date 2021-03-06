#!/usr/bin/env bash
# Update the index
sudo apt-get -y update

# Install c libraries 
sudo apt-get -y install build-essential
# Install vi editor
sudo apt-get -y install vim
sudo apt-get -y install tree
sudo apt-get -y install net-tools
sudo apt-get -y install sshpass
sudo apt-get -y install unzip
sudo apt-get -y install curl

echo "Installing Python 3.7 "
sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt -y update
sudo apt -y install python3.7
echo " Python 3.7 installation complete "

echo "Installing openjdk-8 "
#Adding Open JDK installer
sudo -E add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get -y update
sudo apt-get -y install openjdk-8-jdk
sudo update-ca-certificates -f
echo " Openjdk-8 installation complete "

# Setup SSH
#ssh-keygen -q -t rsa -P "" -f ~/.ssh/id_rsa <<<y 2>&1 >/dev/null

ssh-keygen -q -t rsa -P "" -f ~/.ssh/id_rsa
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/known_hosts

chmod 0600 $HOME/.ssh/authorized_keys

# Verify ssh

ssh -o StrictHostKeyChecking=no $USER@localhost 'sleep 5 && exit'
ssh -o StrictHostKeyChecking=no $USER@0.0.0.0 'sleep 5 && exit'


echo "Installing MySQL Server"
echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections
sudo apt-get -y install mysql-server mysql-client

mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS metastore_db;" 
mysql -uroot -proot -e "CREATE USER 'hiveuser'@'localhost' IDENTIFIED BY 'hivepassword';"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'localhost' identified by 'hivepassword';"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'%' identified by 'hivepassword';"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by 'root';"
mysql -uroot -proot -e "FLUSH PRIVILEGES;"


#Host Name - IP Address resolution
sudo chmod 777 /etc/hosts
cat ./hosts >/etc/hosts
sudo chmod 644 /etc/hosts

#echo "`hostname -I | awk '{print $2}'`  $HOSTNAME" >>/etc/hosts



# Create directory to store the MongoDB document
sudo mkdir -p /data/db
sudo chmod 777 -R /data

# Create directory to store the required software
mkdir -p $HOME/bigdata
cd $HOME/bigdata
pwd

# Create directories for name node and data node
sudo mkdir -p /app/bigdata
sudo chmod 777 -R /app/

mkdir -p /app/bigdata/hadoop_tmp/hdfs/namenode
mkdir -p /app/bigdata/hadoop_tmp/hdfs/datanode

# Create directories for spark-events
mkdir -p /app/bigdata/spark-events
mkdir -p /app/bigdata/spark_tmp/spark
#mkdir -p /tmp/spark-events


mkdir -p /app/bigdata/hive_tmp/hive
mkdir -p /app/bigdata/zookeeper

#---------------- Hadoop Stack Software -------------------------------------------------
# Download hadoop binaries
echo "Dowloading Hadoop"
wget  -q https://downloads.apache.org/hadoop/common/stable2/hadoop-2.10.1.tar.gz

# Download Hive binaries
echo "Dowloading Hive"
#wget -q https://mirrors.estointernet.in/apache/hive/hive-2.3.9/apache-hive-2.3.9-bin.tar.gz
wget -q https://downloads.apache.org/hive/hive-2.3.9/apache-hive-2.3.9-bin.tar.gz


# Download Pig binaries
echo "Dowloading Pig"
wget -q https://downloads.apache.org/pig/pig-0.16.0/pig-0.16.0.tar.gz


# Download Sqoop
echo "Dowloading Sqoop"
wget -q http://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz


# Download HBase
echo "Dowloading HBase"
wget -q https://downloads.apache.org/hbase/1.7.1/hbase-1.7.1-bin.tar.gz

#---------------- Hadoop Stack Software End -------------------------------------------------

# Download Spark pre-built with hadoop 2.7+
echo "Dowloading Spark"

wget -q https://archive.apache.org/dist/spark/spark-3.0.2/spark-3.0.2-bin-hadoop2.7.tgz

echo "Dowloading SBT"
wget -q https://github.com/sbt/sbt/releases/download/v1.2.0/sbt-1.2.0.tgz



# Download jdk binaries
echo "Dowloading Java"
wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz

# Download Scala binaries
echo "Dowloading Scala"
wget -q  https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.tgz



# Download Kafka binaries
echo "Dowloading Kafka"
wget -q https://archive.apache.org/dist/kafka/2.8.0/kafka_2.12-2.8.0.tgz


# Download Apache Cassandra
echo "Dowloading Cassandra"
wget -q http://archive.apache.org/dist/cassandra/3.11.10/apache-cassandra-3.11.10-bin.tar.gz

# Download MongoDB
echo "Dowloading MongoDB"
#wget -q https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.9.tgz
wget -q https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz

# Download MySQL JDBC Driver
echo "Dowloading MySQL JDBC Driver"
wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz

# Download Confluent Community Edition
echo "Dowloading Confluent Community Edition 6.2.0 "
wget -q https://packages.confluent.io/archive/6.2/confluent-community-6.2.0.tar.gz

#=================================================================================================
echo "Hadoop Extraction Started "
# Extract hadoop binaries
tar -xf hadoop-2.10.1.tar.gz
mv hadoop-2.10.1 hadoop
rm hadoop-2.10.1.tar.gz
echo "Hadoop Extraction Completed "

echo "Hive Extraction Started "
# Extract Hive binaries
tar -xf apache-hive-2.3.9-bin.tar.gz
mv apache-hive-2.3.9-bin hive
rm  apache-hive-2.3.9-bin.tar.gz
echo "Hive Extraction Completed "

echo "Pig Extraction Started "
# Extract Pig binaries
tar -xf pig-0.16.0.tar.gz
mv pig-0.16.0 pig
rm pig-0.16.0.tar.gz
echo "Pig Extraction Completed "

echo "Sqoop Extraction Started "
#Extract Sqoop 
tar xf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
mv sqoop-1.4.7.bin__hadoop-2.6.0 sqoop
rm sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
echo "Sqoop Extraction Completed "

#Extract HBase 
echo "HBase Extraction Started "
tar -xf hbase-1.7.1-bin.tar.gz 
mv hbase-1.7.1 hbase
rm hbase-1.7.1-bin.tar.gz
#rm $HOME/bigdata/hbase/lib/slf4j-log4j12-1.7.25.jar 
echo "HBase Extraction Completed "

#===============================================================================================
echo "Spark Extraction Started "
# Extract the Spark  binaries
tar -xf spark-3.0.2-bin-hadoop2.7.tgz
mv spark-3.0.2-bin-hadoop2.7 spark
rm spark-3.0.2-bin-hadoop2.7.tgz
echo "Spark Extraction Completed "

echo "Java Extraction Started "
# Extract java binaries
tar -xf jdk-8u131-linux-x64.tar.gz
mv jdk1.8.0_131 java
rm jdk-8u131-linux-x64.tar.gz
echo "Java Extraction Completed "


echo "Scala Extraction Started "
# Extract Scala binaries
 tar -xf scala-2.12.2.tgz
 mv scala-2.12.2 scala
 rm scala-2.12.2.tgz
echo "Scala Extraction Completed "

echo "SBT Extraction Started "
#Extract sbt 
tar -xf sbt-1.2.0.tgz
rm  sbt-1.2.0.tgz
echo "SBT Extraction Completed "

echo "Kafka Extraction Started "
#Extract Kafka 

tar xf kafka_2.12-2.8.0.tgz
mv kafka_2.12-2.8.0 kafka
rm kafka_2.12-2.8.0.tgz
echo "Kafka Extraction Completed "

echo "Cassandra Extraction Started "
#Extract Cassandra 

tar xf apache-cassandra-3.11.10-bin.tar.gz
mv apache-cassandra-3.11.10 cassandra
rm apache-cassandra-3.11.10-bin.tar.gz
echo "Cassandra Extraction Completed "

echo "MongoDB Extraction Started "
#Extract MongoDB 
#tar xf mongodb-linux-x86_64-4.0.9.tgz
#mv mongodb-linux-x86_64-4.0.9 mongodb
#rm mongodb-linux-x86_64-4.0.9.tgz

tar xf mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz
mv mongodb-linux-x86_64-ubuntu1604-4.2.13 mongodb
rm mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz

echo "MongoDB Extraction Completed "

echo "MySQL JDBC Extraction Started "
#Extract MySQL JDBC Driver 
tar xf mysql-connector-java-5.1.47.tar.gz
mv mysql-connector-java-5.1.47 mysql-connector
rm mysql-connector-java-5.1.47.tar.gz
echo "MySQL JDBC Extraction Completed "

echo "Confluent Community Edition Extraction Started "
tar xf confluent-community-6.2.0.tar.gz
mv confluent-6.2.0 confluent
rm confluent-community-6.2.0.tar.gz
echo "Confluent Community Edition Extraction Completed "

echo "Downloading & Installing Confluent Hub "
cd $HOME/bigdata/confluent/
wget -q http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz
tar xf confluent-hub-client-latest.tar.gz
rm confluent-hub-client-latest.tar.gz
cd $HOME/bigdata/
echo "Download & Installation of Confluent Hub completed"

echo "Downloading & Installing Confluent CLI "
# curl -L --http1.1 https://cnfl.io/cli | sh -s -- -b $CONFLUENT_HOME/bin
cd $HOME/
wget -q https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/latest/confluent_latest_linux_amd64.tar.gz
tar xf confluent_latest_linux_amd64.tar.gz
mv $HOME/confluent/* $HOME/bigdata/confluent/bin/
rm confluent_latest_linux_amd64.tar.gz
rm -rf $HOME/confluent
cd $HOME/bigdata/
echo "Download & Installation of Confluent CLI completed"

echo " Configuring ENVIRONMENT Variables "
# set env variables in .bashrc file
echo 'export JAVA_HOME='$HOME'/bigdata/java' >>$HOME/.bashrc
echo 'export HADOOP_HOME='$HOME'/bigdata/hadoop' >> $HOME/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >>$HOME/.bashrc
echo 'export HIVE_HOME='$HOME'/bigdata/hive' >> $HOME/.bashrc
echo 'export PATH=$PATH:$HIVE_HOME/bin' >> $HOME/.bashrc
echo 'export PIG_HOME='$HOME'/bigdata/pig' >> $HOME/.bashrc
echo 'export PATH=$PATH:$PIG_HOME/bin' >> $HOME/.bashrc
echo 'export SQOOP_HOME='$HOME'/bigdata/sqoop' >> $HOME/.bashrc
echo 'export PATH=$PATH:$SQOOP_HOME/bin' >> $HOME/.bashrc

# set env variables for Hbase
echo 'export HBASE_HOME='$HOME'/bigdata/hbase'>>$HOME/.bashrc
echo 'export PATH=$PATH:$HBASE_HOME/bin'>>$HOME/.bashrc

echo 'export SCALA_HOME='$HOME'/bigdata/scala' >> $HOME/.bashrc
echo 'export PATH=$PATH:$SCALA_HOME/bin' >> $HOME/.bashrc
echo 'export SPARK_HOME='$HOME'/bigdata/spark' >> $HOME/.bashrc
echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >>$HOME/.bashrc
echo 'export SBT_HOME='$HOME'/bigdata/sbt' >> $HOME/.bashrc
echo 'export PATH=$PATH:$SBT_HOME/bin' >> $HOME/.bashrc

echo 'export KAFKA_HOME='$HOME'/bigdata/kafka' >> $HOME/.bashrc
echo 'export PATH=$PATH:$KAFKA_HOME/bin' >> $HOME/.bashrc

echo 'export CASSANDRA_HOME='$HOME'/bigdata/cassandra' >> $HOME/.bashrc
echo 'export PATH=$PATH:$CASSANDRA_HOME/bin' >>$HOME/.bashrc

echo 'export MONGODB_HOME='$HOME'/bigdata/mongodb' >> $HOME/.bashrc
echo 'export PATH=$PATH:$MONGODB_HOME/bin' >> $HOME/.bashrc

echo 'export CONFLUENT_HOME='$HOME'/bigdata/confluent' >>$HOME/.bashrc
echo 'export PATH=$PATH:$CONFLUENT_HOME/bin' >> $HOME/.bashrc

echo 'export PYSPARK_PYTHON=python3.7'>>$HOME/.bashrc

echo $JAVA_HOME

echo " Configuring ENVIRONMENT Variables Completed"


echo " ------------- Copy Hadoop configuraton files -----------------"

# Add JAVA_HOME in hadoop-env.sh
echo 'export JAVA_HOME='$HOME'/bigdata/java' >> $HOME/bigdata/hadoop/etc/hadoop/hadoop-env.sh

# copy hadoop configuraton files from host to the guest VM


cd $HOME/hadoop_light_cloud

cp ./core-site.xml $HOME/bigdata/hadoop/etc/hadoop/
cp ./hdfs-site.xml $HOME/bigdata/hadoop/etc/hadoop/
cp ./mapred-site.xml $HOME/bigdata/hadoop/etc/hadoop/
cp ./yarn-site.xml $HOME/bigdata/hadoop/etc/hadoop/
cp ./masters $HOME/bigdata/hadoop/etc/hadoop/
cp ./slaves $HOME/bigdata/hadoop/etc/hadoop/

echo " ------------- Copy Hadoop configuraton files Done-----------------"

echo " ------------- Copy Hive configuraton files -----------------"

cp ./hive-site.xml $HOME/bigdata/hive/conf/
cp ./hive-env.sh $HOME/bigdata/hive/conf/
cp ./hive-config.sh $HOME/bigdata/hive/bin/
echo " ------------- Copy Hive configuraton files Done-----------------"

echo " ------------- Copy Spark configuraton files -----------------"

# copy Spark configuraton files from host to the guest VM
cp ./slaves $HOME/bigdata/spark/conf/
cp ./spark-env.sh $HOME/bigdata/spark/conf/
cp ./spark-defaults.conf $HOME/bigdata/spark/conf/
cp ./log4j.properties $HOME/bigdata/spark/conf/
# cp ./hive-site.xml $HOME/bigdata/spark/conf/
echo " ------------- Copy Spark configuraton files Done-----------------"

# copy Hive configuraton file into Sqoop conf directory
cp ./hive-site.xml $HOME/bigdata/sqoop/conf/

echo " ------------- Copy HBase configuraton files -----------------"
#HBase related configuration file
cp  ./hbase-site.xml $HOME/bigdata/hbase/conf/
cp  ./hbase-env.sh $HOME/bigdata/hbase/conf/

# copy regionservers file from host to the guest VM  
#cp /vagrant/config/hbase/regionservers /home/vagrant/bigdata/hbase/conf/
echo 'localhost' >$HOME/bigdata/hbase/conf/regionservers

echo " ------------- Copy HBase configuraton files Done-----------------"

echo " ------------- Copy MySQL JDBC Driver files -----------------"
 
#Copy  MySQL JDBC Driver to Hive Directory
cp $HOME/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar $HOME/bigdata/hive/lib/
cp $HOME/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar $HOME/bigdata/sqoop/lib/
cp $HOME/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar $HOME/bigdata/spark/jars/
cp $HOME/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar $HOME/bigdata/kafka/libs/

echo " Configuring JDBC Driver for Confluent "
mkdir -p $HOME/bigdata/confluent/share/java/kafka-connect-jdbc
cp $HOME/bigdata/mysql-connector/*.jar $HOME/bigdata/confluent/share/java/kafka-connect-jdbc/
wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.25.tar.gz
tar xf mysql-connector-java-8.0.25.tar.gz
cp mysql-connector-java-8.0.25/*.jar $HOME/bigdata/confluent/share/java/kafka-connect-jdbc/
echo " Configuring JDBC Driver for Confluent complete"

sudo cp ./my.cnf /etc/mysql/my.cnf	

echo " ------------- Copy MySQL JDBC Driver files Done-----------------"

# copy dataset files from host to the guest VM   
cp  ./dataset.zip $HOME
cp  ./install-connectors.sh $HOME/install-connectors.sh

echo " Copying Configuration Files Completed"

echo " Installing Confluent Kafka Connector "
echo " Installing Confluent Kafka Datagen Connector "
$HOME/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest
echo " Installation Completed of  Confluent Kafka Datagen Connector "

echo " Installing Confluent Kafka JDBC Source/Sink Connector "
$HOME/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.2.0
echo " Installation Completed of  JDBC Source/Sink Connector "

echo " Installing Confluent Kafka HDFS3 Sink Connector "
$HOME/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs3:1.1.1
echo " Installation Completed of  HDFS3 Sink Connector "

echo " Installing Confluent Kafka Debezium Source Connector "
$HOME/bigdata/confluent/bin/confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.5.0
echo " Installation Completed of  Debezium Source Connector "

echo " Installing Confluent Kafka Cassandra Sink Connector "
$HOME/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-cassandra:2.0.0
echo " Installation Completed of  Cassandra Sink Connector "

echo " Installing Confluent Kafka MongoDB Source/Sink Connector "
$HOME/bigdata/confluent/bin/confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.5.1
echo " Installation Completed of  MongoDB Source/Sink Connector "
echo " Installing Confluent Kafka Connector Completed"

echo " ------------- Starting Hadoop Services -----------------"
# Format namenode
$HOME/bigdata/hadoop/bin/hadoop namenode -format

# Start dfs
$HOME/bigdata/hadoop/sbin/start-dfs.sh
#Check if namenode, datanode and secondary namenode has started
$HOME/bigdata/java/bin/jps

# Start yarn
$HOME/bigdata/hadoop/sbin/start-yarn.sh
#Check if resource manager & node manager has started
$HOME/bigdata/java/bin/jps

echo " ------------- Hadoop Services Started-----------------"

# Initialize MySQL for Hive 2
echo "Creating Metastore db for Hive "
$HOME/bigdata/hive/bin/hive --service schemaTool -dbType mysql -initSchema
echo "Metastore db creation for Hive completed "

echo " ------------- Starting Spark Services -----------------"

# Start Spark Master
$HOME/bigdata/spark/sbin/start-master.sh
# Start Spark Slaves
$HOME/bigdata/spark/sbin/start-slaves.sh

#Check if Hadoop Services and Spark Services started 
$HOME/bigdata/java/bin/jps

echo " ------------- Spark Services Started-----------------"

echo " ------------- Running Sample MapReduce Job-----------------"
# Create a input directory in HDFS
$HOME/bigdata/hadoop/bin/hdfs dfs -mkdir -p /user/$USER/wordcount/input

# Copy a local file to the input directory
$HOME/bigdata/hadoop/bin/hdfs dfs -copyFromLocal $HOME/bigdata/hadoop/README.txt /user/$USER/wordcount/input/

# Verify that the file has been copied
$HOME/bigdata/hadoop/bin/hdfs dfs -cat /user/$USER/wordcount/input/README.txt

# Run the wordcount example bundled with the hadoop binaries
$HOME/bigdata/hadoop/bin/hadoop jar $HOME/bigdata/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.10.1.jar wordcount wordcount/input wordcount/output

# Verify the output
$HOME/bigdata/hadoop/bin/hdfs dfs -cat /user/$USER/wordcount/output/part*

#Execute a Spark Example
echo "------------RUNNING SPARK EXAMPLE ------------------------------"
$HOME/bigdata/spark/bin/run-example SparkPi 10

# Check whether the Spark shell is running in local mode
#$HOME/bigdata/spark/bin/spark-shell --master local[*]

# Run Spark shell is running in YARN mode
# $HOME/bigdata/spark/bin/spark-shell --master spark://master:7077

cd ~

echo " Your environment is ready"
