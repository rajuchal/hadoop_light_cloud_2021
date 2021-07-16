# hadoop_light_cloud_2021
## Automated Setup & Installation Guide 
## for Hadoop Single Node Cluster Environment on Linux VM (On-Premise / Cloud)
## using light-weight script with Spark/Kafka/Confluent/Cassandra/MongoDB/MySQL
### (Pseudo Distributed mode)
##### ==============================================================================

#### Single Node _Hadoop/Spark/HBase/Kafka/Cassandra/MongoDB_ Cluster on Ubuntu Linux
#### Tested on Ubuntu-18.04 LTS (Bionic Beaver)

Automation Script for creating single node _hadoop/spark/kafka/cassanda/mongodb_ cluster on Ubuntu Linux 

#### Note :- During execution of the script, The Desktop/Laptop with root permission should be connected to Internet
##### ==============================================================================

### Functions of the template & script -
## Install Hadoop stack, Spark, Kafka, Cassandra, MongoDB, Confluent into Linux VM

##### ==============================================================================
### Pre-requisite Software/Configuration
#### Password-less sudo access of the Linux User

1. Download SmarTTY

	https://sysprogs.com/SmarTTY/download/
	
	OR
	
	Download MobaXTerm
	
	https://mobaxterm.mobatek.net/download-home-edition.html

2. Download WinSCP

	https://winscp.net/eng/download.php
	

	
##### ==================================================
###  INSTALLATION PROCESS
##### ==================================================

#### Pre-requisite :- During entire installation procedure your Laptop/Desktop should be connected with Internet.
#### Minimum RAM Required :- 8 GB

1. Download the script file in Windows

      ##### $ sudo apt-get install unzip 

      ##### $ wget https://github.com/rajuchal/hadoop_light_cloud_2021/archive/refs/heads/master.zip

2. _"master.zip"_ file will be downloaded , Unzip the file "master.zip"

      ##### $ ls
      ##### $ unzip master.zip
      ##### $ ls

3. Change the extracted folder name

      ##### $ mv hadoop_light_cloud_2021-master hadoop_light_cloud
      ##### $ cd hadoop_light_cloud
      ##### $ ls

4. Change the permission & run the "install.sh" script

      ##### $ chmod 755 install.sh

      ##### $ ./install.sh


      ##### ------------- Wait till you get back the $ Prompt with message 'Your environment is ready'
      ##### ------------- Depending on the bandwidh total installation may take 25 mins to 35 minutes time

6. After getting back the $ Prompt execute the below commands 

      ##### $ cd ~
      ##### $ source .bashrc

      ##### $ jps

		11538 Jps
		9716 DataNode
		9942 SecondaryNameNode
		10520 Master
		9528 NameNode
		10107 ResourceManager
		10446 NodeManager
		10750 Worker

#### Restart your system & Start the services

##### ==========================================================================
##### USE SmarTTY/MobaXTerm/ WinSCP to Connect with the Linux Node fron Windows

##### ===========================================================================

#### For details installation & setup , check the pdf guide file.

##### =============================================================================

#### Commands to start services

##### =============================================================================

1. Start Hadoop Services in Linux VM
    ##### $ start-dfs.sh
    ##### $ start-yarn.sh

2. Start Spark Services in Linux VM
    ##### $ start-master.sh
    ##### $ start-slaves.sh

3. Start Spark(Scala/Java) Shell  in Linux VM

    ##### $ spark-shell --master spark://localhost:7077

4. Start Spark(Python) Shell  in Linux VM

    ##### $ pyspark --master spark://localhost:7077

5. Start Hive  in Linux VM

    ##### $ hive

### *Note-*
#### Installation directory in Linux VM - /$HOME/bigdata
#### User Name & Password of the Linux VM will be shared with you.
#### ---------------------------------------------------------
#### Issue to start MongoDB service in Ubuntu 18.04.5 LTS
#### Before Starting MongoDB Service, install the library shown below
 ###  $ sudo apt-get -y install libcurl3
#### Please note that, It will remove the “curl” command



:+1: **_Happy Clustering_** :shipit:
