FROM mitre-centos

ARG flag

RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
RUN rpm -ivh epel-release-7-10.noarch.rpm

RUN yum update
RUN yum install -y gcc socat pwgen

RUN useradd -m -s /bin/bash ctf

WORKDIR /home/ctf
COPY verify.c .
RUN gcc verify.c -o challenge
RUN echo "${flag}" > flag
RUN pwgen -ys 20 1 > key

USER ctf
EXPOSE 1337
CMD /usr/bin/socat TCP-LISTEN:1337,fork,reuseaddr exec:/home/ctf/challenge,stderr,pty,echo=0
