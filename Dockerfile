FROM centos:7
MAINTAINER "Max Rydahl Andersen" <docker@xam.dk>

## Enabel EPEL where imapfilter is available from
RUN yum -y install epel-release && yum -y update

RUN yum -y install git-core lua5.2 libpcr3 libssl1.0.0 liblua5.2
#RUN yum -y install build-essential libpcre3-dev libssl-dev liblua5.2-dev
RUN yum -y install make
RUN yum -y install gcc
RUN yum -y install openssl-devel
RUN yum -y install lua-devel


WORKDIR /source

RUN git clone https://github.com/lefcha/imapfilter.git .

RUN make all
RUN make install

#RUN yum -y install imapfilter

## Cleanup to save some space
RUN yum clean all

RUN mkdir /imapfilter

ADD imapfilter.sh /imapfilter/imapfilter.sh

RUN chmod +x /imapfilter/imapfilter.sh

RUN groupadd -r imapfilter -g 1000 && \
useradd -u 1000 -r -g imapfilter -d /imapfilter -s /sbin/nologin -c "imapfilter user" imapfilter

RUN chown -R imapfilter:imapfilter /imapfilter

## according https://docs.openshift.com/enterprise/3.1/creating_images/guidelines.html
## user should be numerical instead of username for security reasons.
USER 1000

VOLUME /imapfilter/.imapfilter

## ENTRYPOINT ["/imapfilter/imapfilter.sh"]

## CMD ["fakepwd"]


