FROM ubuntu:trusty-20150806
MAINTAINER Alex Brandt <alunduil@alunduil.com>
MAINTAINER Scott Fan <fancp2007@gmail.com>

#RUN sed -i.bak 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update \
 && apt-get install -y vim.tiny wget sudo net-tools ca-certificates unzip \
 && apt-get install -y mysql-client postgresql-client apache2-mpm-event php5 php-pear php5-mysql php5-pgsql php5-sqlite \
 && pear install mail_mime mail_mimedecode net_smtp net_idna2-beta auth_sasl net_sieve crypt_gpg \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && locale-gen en_US.UTF-8 \
 && dpkg-reconfigure locales \
 && rm -rf /var/lib/apt/lists/*

ENV RCMAIL_INSTALL_DIR="/var/www"

ENV RCMAIL_CERTS_DIR="${RCMAIL_INSTALL_DIR}/certs" \
        RCMAIL_DATA_DIR="${RCMAIL_INSTALL_DIR}/data" \
        RCMAIL_LOG_DIR="${RCMAIL_INSTALL_DIR}/logs"

RUN rm -rf ${RCMAIL_INSTALL_DIR}
ADD . ${RCMAIL_INSTALL_DIR}

RUN rm -rf ${RCMAIL_INSTALL_DIR}/installer
RUN rm -rf ${RCMAIL_INSTALL_DIR}/entrypoint.sh
RUN rm -rf ${RCMAIL_INSTALL_DIR}/Dockerfile
RUN rm -rf ${RCMAIL_INSTALL_DIR}/docker-compose.yml

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80/tcp 443/tcp

VOLUME ["${RCMAIL_CERTS_DIR}", "${RCMAIL_DATA_DIR}", "${RCMAIL_LOG_DIR}"]
WORKDIR ${RCMAIL_INSTALL_DIR}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]
