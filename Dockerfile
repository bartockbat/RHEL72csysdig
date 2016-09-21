FROM registry.access.redhat.com/rhel7.2:latest

MAINTAINER Redhat

ENV SYSDIG_REPOSITORY stable

#Recommended Atomic Run LABEL
#LABEL RUN="docker run -i -t -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro -v /boot:/host/boot:ro -v /lib/modules:/host/lib/modules:ro -v /usr:/host/usr:ro --name NAME IMAGE"
LABEL RUN="docker run -i -t -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro -v /boot:/host/boot:ro -v /lib/modules:/host/lib/modules:ro -v /usr:/host/usr:ro --name glen_sysdigro --privileged=true rhel7/sysdig"

#recommended LABELS for RHEL7 
LABEL Name Sysdig/Csysdig
LABEL Version sysdig version 0.10.1
LABEL Vendor Sysdig
LABEL Release Opensource Edition

ENV SYSDIG_HOST_ROOT /host

ENV HOME /root

RUN yum repolist --disablerepo=* && \
    yum-config-manager --disable \* > /dev/null && \
    yum-config-manager --enable rhel-7-server-rpms > /dev/null

ADD http://download.draios.com/stable/rpm/draios.repo /etc/yum.repos.d/draios.repo

RUN rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public

#RUN rpm -ivh http://mirror.us.leaseweb.net/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#RUN yum -y install curl gcc
RUN yum -y install dkms

RUN yum -y install sysdig


RUN rm -rf /usr/bin/gcc \
 && ln -s /usr/bin/gcc-4.9 /usr/bin/gcc \
 && ln -s /usr/bin/gcc-4.8 /usr/bin/gcc-4.7 \
 && ln -s /usr/bin/gcc-4.8 /usr/bin/gcc-4.6

RUN ln -s $SYSDIG_HOST_ROOT/lib/modules /lib/modules

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bash"]
