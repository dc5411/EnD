#Container: EnDBoss
#Suggested ports: 8080 (web) + 8081 (ssh)
FROM debian:buster-slim
#Basic userland
RUN apt update
RUN apt install -y build-essential ruby-dev bundler apache2 openssh-server iputils-ping nano sudo __PLACEHOLDER_EXTRA_PKG__
#Folders & Permissions
RUN mkdir /data
RUN chmod -R 777 /tmp/
RUN chmod -R 777 /data/
#App settings & files
WORKDIR /root
COPY ./index.html /var/www/html/index.html
COPY ./launcher.sh ./
COPY ./boss.rb ./
__PLACEHOLDER_EXTRA_FILES__
#Clean
RUN apt autoremove -y
RUN rm -rf /var/lib/apt/lists/*
#Run
CMD bash /root/launcher.sh && sleep infinity