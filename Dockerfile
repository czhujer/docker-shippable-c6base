FROM centos:centos6.8

ADD . /c6base

ADD utils/lsb_release \
  /usr/bin/lsb_release

RUN yum update -y -q

RUN yum install git openssh-clients wget glibc-devel gcc autoconf gettext texinfo -q -y \
    && rm -rf /var/cache/yum/* \
    && yum clean all

RUN wget http://ftp.gnu.org/gnu/glibc/glibc-2.15.tar.gz \
    && tar -xvzf glibc-2.15.tar.gz \
    && rm -f /glibc-2.15.tar.gz

RUN cd glibc-2.15 && mkdir glibc-build

RUN cd /glibc-2.15 && sed -i -e 's/"db1"/& \&\& $name ne "nss_test1"/' scripts/test-installation.pl

RUN cd /glibc-2.15/glibc-build \
    && ../configure --prefix='/usr' \
    && make 1>/dev/null \
    && make install \
    && rm -rf glibc-2.15
