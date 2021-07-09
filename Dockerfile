#Put jdk-8u66-linux-x64.tar.gz and jce_policy-8.zip at the location with DockerFile
#Using RHEL 7 Base Image
FROM centos:7

#Create Install Directory
RUN yum install -y unzip && \
mkdir -p /mnt/install  && \
mkdir -p /root/chunkcode/lib && \
mkdir -p /root/chunkcode/json

#Copy JDK Tarball
COPY jdk-8u66-linux-x64.tar.gz /mnt/install/

#Extract JDK Tarball
RUN cd /mnt/install && \
tar -zxf jdk-8u66-linux-x64.tar.gz && \
rm -f jdk-8u66-linux-x64.tar.gz

#Set JAVA_HOME
ENV JAVA_HOME /mnt/install/jdk1.8.0_66

#Set PATH
ENV PATH "${PATH}:${JAVA_HOME}/bin"

#Copy JCE policy
COPY jce_policy-8.zip /mnt/install/

#Extract JCE policy
RUN cd /mnt/install && \
unzip jce_policy-8.zip && \
rm -f jce_policy-8.zip && \
cp UnlimitedJCEPolicyJDK8/*.jar ${JAVA_HOME}/jre/lib/security

COPY etc_hosts /tmp/
RUN cat /tmp/etc_hosts >> /etc/hosts 

#Install hdp2.6.1 hbase
RUN yum install -y wget
RUN wget -nv http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.1.0/hdp.repo -O /etc/yum.repos.d/hdp.repo
#RUN yum list hbase
RUN yum install -y hbase

COPY hdp_hbase_conf/ /tmp/
RUN cat /tmp/hbase-site.xml > /etc/hbase/conf/hbase-site.xml
RUN cat /tmp/hbase-env.sh > /etc/hbase/conf/hbase-env.sh

#Copy necessary depencies for application
COPY AIM-FileChunk/lib/ AIM-FileChunk/hadooplib/ /root/chunkcode/lib/
COPY AIM-FileChunk/build/arcfilechunk.jar /root/chunkcode/arcfilechunk-fna.jar
COPY AIM-FileChunk/chunkSettings.json /root/chunkcode/json/
COPY hdp_hbase_conf/ /etc/hbase/conf/

#Run Stitch 
#RUN java -cp /root/chunkcode/arcfilechunk-fna.jar:/root/chunkcode/lib/*:/etc/hbase/conf com.arc.umq.service.PollerService AimStitch1 arcfilechunk-aim-stitch1 &
