#!/bin/bash
set -e

[[ -n $DEBUG_ENTRYPOINT ]] && set -x

#SYSCONF_TEMPLATES_DIR="${SETUP_DIR}/config"
#USERCONF_TEMPLATES_DIR="${RCMAIL_DATA_DIR}/config"

RCMAIL_CONF_DIR="${RCMAIL_INSTALL_DIR}/config"
RCMAIL_TEMP_DIR="${RCMAIL_INSTALL_DIR}/temp"

#RCMAIL_BACKUP_DIR="${RCMAIL_BACKUP_DIR:-$RCMAIL_DATA_DIR/backups}"
#RCMAIL_REPOS_DIR="${RCMAIL_REPOS_DIR:-$RCMAIL_DATA_DIR/repositories}"
#RCMAIL_HOST=${RCMAIL_HOST:-localhost}
#RCMAIL_PORT=${RCMAIL_PORT:-}
#RCMAIL_SSH_HOST=${RCMAIL_SSH_HOST:-$RCMAIL_HOST}
#RCMAIL_SSH_PORT=${RCMAIL_SSH_PORT:-$RCMAIL_SHELL_SSH_PORT} # for backwards compatibility
#RCMAIL_SSH_PORT=${RCMAIL_SSH_PORT:-22}
#RCMAIL_EMAIL=${RCMAIL_EMAIL:-example@example.com}
#RCMAIL_EMAIL_DISPLAY_NAME=${RCMAIL_EMAIL_DISPLAY_NAME:-GitLab}
#RCMAIL_EMAIL_REPLY_TO=${RCMAIL_EMAIL_REPLY_TO:-noreply@example.com}
#RCMAIL_TIMEZONE=${RCMAIL_TIMEZONE:-UTC}
#RCMAIL_USERNAME_CHANGE=${RCMAIL_USERNAME_CHANGE:-true}
#RCMAIL_CREATE_GROUP=${RCMAIL_CREATE_GROUP:-true}
#RCMAIL_PROJECTS_ISSUES=${RCMAIL_PROJECTS_ISSUES:-true}
#RCMAIL_PROJECTS_MERGE_REQUESTS=${RCMAIL_PROJECTS_MERGE_REQUESTS:-true}
#RCMAIL_PROJECTS_WIKI=${RCMAIL_PROJECTS_WIKI:-true}
#RCMAIL_PROJECTS_SNIPPETS=${RCMAIL_PROJECTS_SNIPPETS:-false}
#RCMAIL_RELATIVE_URL_ROOT=${RCMAIL_RELATIVE_URL_ROOT:-}
#RCMAIL_WEBHOOK_TIMEOUT=${RCMAIL_WEBHOOK_TIMEOUT:-10}
#RCMAIL_SATELLITES_TIMEOUT=${RCMAIL_SATELLITES_TIMEOUT:-30}
#RCMAIL_TIMEOUT=${RCMAIL_TIMEOUT:-10}

#SSL_SELF_SIGNED=${SSL_SELF_SIGNED:-false}
#SSL_CERTIFICATE_PATH=${SSL_CERTIFICATE_PATH:-$RCMAIL_DATA_DIR/certs/gitlab.crt}
#SSL_KEY_PATH=${SSL_KEY_PATH:-$RCMAIL_DATA_DIR/certs/gitlab.key}
#SSL_DHPARAM_PATH=${SSL_DHPARAM_PATH:-$RCMAIL_DATA_DIR/certs/dhparam.pem}
#SSL_VERIFY_CLIENT=${SSL_VERIFY_CLIENT:-off}

#CA_CERTIFICATES_PATH=${CA_CERTIFICATES_PATH:-$RCMAIL_DATA_DIR/certs/ca.crt}

RCMAIL_HTTPS=${RCMAIL_HTTPS:-false}

RCMAIL_SSL_SELF_SIGNED=${SSL_SELF_SIGNED:-false}
RCMAIL_SSL_CERTIFICATE_PATH=${RCMAIL_SSL_CERTIFICATE_PATH:-$RCMAIL_CERTS_DIR/roundcube.crt}
RCMAIL_SSL_KEY_PATH=${RCMAIL_SSL_KEY_PATH:-$RCMAIL_CERTS_DIR/roundcube.key}

MAIL_DOMAIN=${MAIL_DOMAIN:-gmail.com}
USERNAME_DOMAIN=${USERNAME_DOMAIN:-gmail.com}

IMAP_HOST=${IMAP_HOST:-imap.gmail.com}
IMAP_PORT=${IMAP_PORT:-993}
IMAP_SSL=${IMAP_SSL:-}

SMTP_HOST=${SMTP_HOST:-smtp.gmail.com}
SMTP_PORT=${SMTP_PORT:-587}
SMTP_SSL=${SMTP_SSL:-}

SMTP_USER=${SMTP_USER:-%u}
SMTP_PASS=${SMTP_PASS:-%p}
#SMTP_OPENSSL_VERIFY_MODE=${SMTP_OPENSSL_VERIFY_MODE:-none}
#SMTP_STARTTLS=${SMTP_STARTTLS:-true}

SMTP_CA_ENABLED=${SMTP_CA_ENABLED:-false}
SMTP_CA_PATH=${SMTP_CA_PATH:-$RCMAIL_DATA_DIR/certs}
SMTP_CA_FILE=${SMTP_CA_FILE:-$RCMAIL_DATA_DIR/certs/ca.crt}

#if [[ -n ${SMTP_USER} ]]; then
  #SMTP_ENABLED=${SMTP_ENABLED:-true}
  #SMTP_AUTHENTICATION=${SMTP_AUTHENTICATION:-login}
#fi
#SMTP_ENABLED=${SMTP_ENABLED:-false}
#RCMAIL_EMAIL_ENABLED=${RCMAIL_EMAIL_ENABLED:-$SMTP_ENABLED}

#RCMAIL_HTTPS_HSTS_ENABLED=${RCMAIL_HTTPS_HSTS_ENABLED:-true}
#RCMAIL_HTTPS_HSTS_MAXAGE=${RCMAIL_HTTPS_HSTS_MAXAGE:-31536000}


DB_TYPE=${DB_TYPE:-sqlite}
DB_HOST=${DB_HOST:-}
DB_PORT=${DB_PORT:-}
DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}
DB_POOL=${DB_POOL:-10}

# is a mysql or postgresql database linked?
# requires that the mysql or postgresql containers have exposed
# port 3306 and 5432 respectively.
if [[ -n ${MYSQL_PORT_3306_TCP_ADDR} ]]; then
  DB_TYPE=${DB_TYPE:-mysql}
  DB_HOST=${DB_HOST:-${MYSQL_PORT_3306_TCP_ADDR}}
  DB_PORT=${DB_PORT:-${MYSQL_PORT_3306_TCP_PORT}}

  # support for linked sameersbn/mysql image
  DB_USER=${DB_USER:-${MYSQL_ENV_DB_USER}}
  DB_PASS=${DB_PASS:-${MYSQL_ENV_DB_PASS}}
  DB_NAME=${DB_NAME:-${MYSQL_ENV_DB_NAME}}

  # support for linked orchardup/mysql and enturylink/mysql image
  # also supports official mysql image
  DB_USER=${DB_USER:-${MYSQL_ENV_MYSQL_USER}}
  DB_PASS=${DB_PASS:-${MYSQL_ENV_MYSQL_PASSWORD}}
  DB_NAME=${DB_NAME:-${MYSQL_ENV_MYSQL_DATABASE}}
elif [[ -n ${POSTGRESQL_PORT_5432_TCP_ADDR} ]]; then
  DB_TYPE=${DB_TYPE:-postgres}
  DB_HOST=${DB_HOST:-${POSTGRESQL_PORT_5432_TCP_ADDR}}
  DB_PORT=${DB_PORT:-${POSTGRESQL_PORT_5432_TCP_PORT}}

  # support for linked official postgres image
  DB_USER=${DB_USER:-${POSTGRESQL_ENV_POSTGRES_USER}}
  DB_PASS=${DB_PASS:-${POSTGRESQL_ENV_POSTGRES_PASSWORD}}
  DB_NAME=${DB_NAME:-${DB_USER}}

  # support for linked sameersbn/postgresql image
  DB_USER=${DB_USER:-${POSTGRESQL_ENV_DB_USER}}
  DB_PASS=${DB_PASS:-${POSTGRESQL_ENV_DB_PASS}}
  DB_NAME=${DB_NAME:-${POSTGRESQL_ENV_DB_NAME}}

  # support for linked orchardup/postgresql image
  DB_USER=${DB_USER:-${POSTGRESQL_ENV_POSTGRESQL_USER}}
  DB_PASS=${DB_PASS:-${POSTGRESQL_ENV_POSTGRESQL_PASS}}
  DB_NAME=${DB_NAME:-${POSTGRESQL_ENV_POSTGRESQL_DB}}

  # support for linked paintedfox/postgresql image
  DB_USER=${DB_USER:-${POSTGRESQL_ENV_USER}}
  DB_PASS=${DB_PASS:-${POSTGRESQL_ENV_PASS}}
  DB_NAME=${DB_NAME:-${POSTGRESQL_ENV_DB}}
fi

echo "<?php" > ${RCMAIL_CONF_DIR}/config.inc.php
echo "" >> ${RCMAIL_CONF_DIR}/config.inc.php
echo "\$config = array();" >> ${RCMAIL_CONF_DIR}/config.inc.php

# configure database
if [[ ${DB_TYPE} == sqlite ]]; then
    echo "\$config['db_dsnw'] = 'sqlite:////var/www/data/sqlite.db?mode=0646';" >> ${RCMAIL_CONF_DIR}/config.inc.php
else
    if [[ ${DB_TYPE} == mysql || ${DB_TYPE} == postgres ]]; then
        if [[ -z ${DB_HOST} ]]; then
            echo "ERROR: "
            echo "  Please configure the database connection."
            echo "  Cannot continue without a database. Aborting..."
            exit 1
        fi

        # use default port number if it is still not set
        case ${DB_TYPE} in
            mysql) DB_PORT=${DB_PORT:-3306} ;;
            postgres) DB_PORT=${DB_PORT:-5432} ;;
        esac

        # set default user and database
        DB_USER=${DB_USER:-root}
        DB_NAME=${DB_NAME:-gitlabhq_production}

        case ${DB_TYPE} in
            mysql) DB_PROVIDER="mysql" ;;
            postgres) DB_PROVIDER="pgsql" ;;
        esac

        echo "\$config['db_dsnw'] = '${DB_PROVIDER}://${DB_USER}:${DB_PASS}@${DB_HOST}/${DB_NAME}';" >> ${RCMAIL_CONF_DIR}/config.inc.php
    else
        echo "Invalid database type: '$DB_TYPE'. Supported choices: [sqlite, mysql, postgres]."
        exit 1
    fi
fi

# imap
case ${IMAP_SSL} in
    ssl) echo "\$config['default_host'] = 'ssl://${IMAP_HOST}';" >>  ${RCMAIL_CONF_DIR}/config.inc.php ;;
    tls) echo "\$config['default_host'] = 'tls://${IMAP_HOST}';" >>  ${RCMAIL_CONF_DIR}/config.inc.php ;;
    *) IMAP_SSL="" && echo "\$config['default_host'] = '${IMAP_HOST}' ;" >>  ${RCMAIL_CONF_DIR}/config.inc.php ;;
esac
echo "\$config['default_port'] = ${IMAP_PORT};" >>  ${RCMAIL_CONF_DIR}/config.inc.php

if [[ -n ${IMAP_SSL} && -f ${IMAP_CA_FILE} ]]; then
    echo "\$config['imap_conn_options'] = array('${IMAP_SSL}'=>array('cafile'=>'${IMAP_CA_FILE}'));" >>  ${RCMAIL_CONF_DIR}/config.inc.php
fi

# smtp
case ${SMTP_SSL} in
    ssl) echo "\$config['smtp_server'] = 'ssl://${SMTP_HOST}';" >>  ${RCMAIL_CONF_DIR}/config.inc.php ;;
    tls) echo "\$config['smtp_server'] = 'tls://${SMTP_HOST}';" >>  ${RCMAIL_CONF_DIR}/config.inc.php ;;
    *) SMTP_SSL="" && echo "\$config['smtp_server'] = '${SMTP_HOST} ;" >>  ${RCMAIL_CONF_DIR}/config.inc.php ;;
esac
echo "\$config['smtp_port'] = ${SMTP_PORT};" >>  ${RCMAIL_CONF_DIR}/config.inc.php

if [[ -n ${SMTP_USER} ]]; then
    echo "\$config['smtp_user'] = '${SMTP_USER}';" >>  ${RCMAIL_CONF_DIR}/config.inc.php
fi
if [[ -n ${SMTP_PASS} ]]; then
    echo "\$config['smtp_pass'] = '${SMTP_PASS}';" >>  ${RCMAIL_CONF_DIR}/config.inc.php
fi

if [[ -n ${SMTP_SSL} && -f ${SMTP_CA_FILE} ]]; then
    echo "\$config['smtp_conn_options'] = array('${SMTP_SSL}'=>array('cafile'=>'${SMTP_CA_FILE}'));" >>  ${RCMAIL_CONF_DIR}/config.inc.php
fi

# domain
if [[ -n ${MAIL_DOMAIN} ]]; then
    echo "\$config['mail_domain'] = '${MAIL_DOMAIN}';" >>  ${RCMAIL_CONF_DIR}/config.inc.php
fi
if [[ -n ${USERNAME_DOMAIN} ]]; then
    echo "\$config['username_domain'] = '${USERNAME_DOMAIN}';" >>  ${RCMAIL_CONF_DIR}/config.inc.php
fi

## is a redis container linked?
#if [[ -n ${REDISIO_PORT_6379_TCP_ADDR} ]]; then
  #REDIS_HOST=${REDIS_HOST:-${REDISIO_PORT_6379_TCP_ADDR}}
  #REDIS_PORT=${REDIS_PORT:-${REDISIO_PORT_6379_TCP_PORT}}
#fi

## fallback to default redis port
#REDIS_PORT=${REDIS_PORT:-6379}

#if [[ -z ${REDIS_HOST} ]]; then
  #echo "ERROR: "
  #echo "  Please configure the redis connection."
  #echo "  Refer http://git.io/PMnRSw for more information."
  #echo "  Cannot continue without a redis connection. Aborting..."
  #exit 1
#fi

sed -e 's|/var/www/html|/var/www/public_html|' -e 's@\(Log \+\)[^ ]\+@\1"|/bin/cat"@' -i /etc/apache2/sites-available/000-default.conf
a2ensite 000-default >/dev/null 2>&1
a2enmod expires >/dev/null 2>&1
a2enmod headers >/dev/null 2>&1

case ${RCMAIL_HTTPS} in
  true)
    RCMAIL_PORT=${RCMAIL_PORT:-443}
    sed -e 's|/var/www/html|/var/www/public_html|' -e 's@\(Log \+\)[^ ]\+@\1"|/bin/cat"@' -i /etc/apache2/sites-available/default-ssl.conf
    if [[ -f ${RCMAIL_SSL_CERTIFICATE_PATH} && -f ${RCMAIL_SSL_KEY_PATH} ]]; then
        sed -e "s,\(^\s*SSLCertificateFile\s\+\)[^ ]\+,\1${RCMAIL_SSL_CERTIFICATE_PATH}," -i /etc/apache2/sites-available/default-ssl.conf
        sed -e "s,\(^\s*SSLCertificateKeyFile\s\+\)[^ ]\+,\1${RCMAIL_SSL_KEY_PATH}," -i /etc/apache2/sites-available/default-ssl.conf
    fi
    a2ensite default-ssl >/dev/null 2>&1
    a2enmod ssl >/dev/null 2>&1
    ;;
  *)
    RCMAIL_PORT=${RCMAIL_PORT:-80}
    ;;
esac


## populate ${RCMAIL_LOG_DIR}
#mkdir -m 0755 -p ${RCMAIL_LOG_DIR}/supervisor   && chown -R root:root ${RCMAIL_LOG_DIR}/supervisor
#mkdir -m 0755 -p ${RCMAIL_LOG_DIR}/nginx        && chown -R ${RCMAIL_USER}:${RCMAIL_USER} ${RCMAIL_LOG_DIR}/nginx
#mkdir -m 0755 -p ${RCMAIL_LOG_DIR}/gitlab       && chown -R ${RCMAIL_USER}:${RCMAIL_USER} ${RCMAIL_LOG_DIR}/gitlab
#mkdir -m 0755 -p ${RCMAIL_LOG_DIR}/gitlab-shell && chown -R ${RCMAIL_USER}:${RCMAIL_USER} ${RCMAIL_LOG_DIR}/gitlab-shell

#cd ${RCMAIL_INSTALL_DIR}

## copy configuration templates
#case ${RCMAIL_HTTPS} in
  #true)
    #if [[ -f ${SSL_CERTIFICATE_PATH} && -f ${SSL_KEY_PATH} && -f ${SSL_DHPARAM_PATH} ]]; then
      #cp ${SYSCONF_TEMPLATES_DIR}/nginx/gitlab-ssl /etc/nginx/sites-enabled/gitlab
    #else
      #echo "SSL keys and certificates were not found."
      #echo "Assuming that the container is running behind a HTTPS enabled load balancer."
      #cp ${SYSCONF_TEMPLATES_DIR}/nginx/gitlab /etc/nginx/sites-enabled/gitlab
    #fi
    #;;
  #*) cp ${SYSCONF_TEMPLATES_DIR}/nginx/gitlab /etc/nginx/sites-enabled/gitlab ;;
#esac

#sudo -HEu ${RCMAIL_USER} cp ${SYSCONF_TEMPLATES_DIR}/gitlab-shell/config.yml    ${RCMAIL_SHELL_INSTALL_DIR}/config.yml
#sudo -HEu ${RCMAIL_USER} cp ${SYSCONF_TEMPLATES_DIR}/gitlabhq/gitlab.yml        config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} cp ${SYSCONF_TEMPLATES_DIR}/gitlabhq/resque.yml        config/resque.yml
#sudo -HEu ${RCMAIL_USER} cp ${SYSCONF_TEMPLATES_DIR}/gitlabhq/database.yml      config/database.yml
#sudo -HEu ${RCMAIL_USER} cp ${SYSCONF_TEMPLATES_DIR}/gitlabhq/unicorn.rb        config/unicorn.rb
#sudo -HEu ${RCMAIL_USER} cp ${SYSCONF_TEMPLATES_DIR}/gitlabhq/rack_attack.rb    config/initializers/rack_attack.rb
#[[ ${SMTP_ENABLED} == true ]] && \
#sudo -HEu ${RCMAIL_USER} cp ${SYSCONF_TEMPLATES_DIR}/gitlabhq/smtp_settings.rb  config/initializers/smtp_settings.rb

## allow to override robots.txt to block bots
#[[ ${RCMAIL_ROBOTS_OVERRIDE} == true ]] && \
#sudo -HEu ${RCMAIL_USER} cp ${RCMAIL_ROBOTS_PATH} public/robots.txt

## override default configuration templates with user templates
#case ${RCMAIL_HTTPS} in
  #true)
    #if [[ -f ${SSL_CERTIFICATE_PATH} && -f ${SSL_KEY_PATH} && -f ${SSL_DHPARAM_PATH} ]]; then
      #[[ -f ${USERCONF_TEMPLATES_DIR}/nginx/gitlab-ssl ]] && cp ${USERCONF_TEMPLATES_DIR}/nginx/gitlab-ssl /etc/nginx/sites-enabled/gitlab
    #else
      #[[ -f ${USERCONF_TEMPLATES_DIR}/nginx/gitlab ]] && cp ${USERCONF_TEMPLATES_DIR}/nginx/gitlab /etc/nginx/sites-enabled/gitlab
    #fi
    #;;
  #*) [[ -f ${USERCONF_TEMPLATES_DIR}/nginx/gitlab ]] && cp ${USERCONF_TEMPLATES_DIR}/nginx/gitlab /etc/nginx/sites-enabled/gitlab ;;
#esac

#[[ -f ${USERCONF_TEMPLATES_DIR}/gitlab-shell/config.yml ]]   && sudo -HEu ${RCMAIL_USER} cp ${USERCONF_TEMPLATES_DIR}/gitlab-shell/config.yml   ${RCMAIL_SHELL_INSTALL_DIR}/config.yml
#[[ -f ${USERCONF_TEMPLATES_DIR}/gitlabhq/gitlab.yml ]]       && sudo -HEu ${RCMAIL_USER} cp ${USERCONF_TEMPLATES_DIR}/gitlabhq/gitlab.yml       config/gitlab.yml
#[[ -f ${USERCONF_TEMPLATES_DIR}/gitlabhq/resque.yml ]]       && sudo -HEu ${RCMAIL_USER} cp ${USERCONF_TEMPLATES_DIR}/gitlabhq/resque.yml       config/resque.yml
#[[ -f ${USERCONF_TEMPLATES_DIR}/gitlabhq/database.yml ]]     && sudo -HEu ${RCMAIL_USER} cp ${USERCONF_TEMPLATES_DIR}/gitlabhq/database.yml     config/database.yml
#[[ -f ${USERCONF_TEMPLATES_DIR}/gitlabhq/unicorn.rb ]]       && sudo -HEu ${RCMAIL_USER} cp ${USERCONF_TEMPLATES_DIR}/gitlabhq/unicorn.rb       config/unicorn.rb
#[[ -f ${USERCONF_TEMPLATES_DIR}/gitlabhq/rack_attack.rb ]]   && sudo -HEu ${RCMAIL_USER} cp ${USERCONF_TEMPLATES_DIR}/gitlabhq/rack_attack.rb   config/initializers/rack_attack.rb
#[[ ${SMTP_ENABLED} == true ]] && \
#[[ -f ${USERCONF_TEMPLATES_DIR}/gitlabhq/smtp_settings.rb ]] && sudo -HEu ${RCMAIL_USER} cp ${USERCONF_TEMPLATES_DIR}/gitlabhq/smtp_settings.rb config/initializers/smtp_settings.rb

#if [[ -f ${SSL_CERTIFICATE_PATH} || -f ${CA_CERTIFICATES_PATH} ]]; then
  #echo "Updating CA certificates..."
  #[[ -f ${SSL_CERTIFICATE_PATH} ]] && cp "${SSL_CERTIFICATE_PATH}" /usr/local/share/ca-certificates/gitlab.crt
  #[[ -f ${CA_CERTIFICATES_PATH} ]] && cp "${CA_CERTIFICATES_PATH}" /usr/local/share/ca-certificates/ca.crt
  #update-ca-certificates --fresh >/dev/null
#fi

## configure application paths
#sudo -HEu ${RCMAIL_USER} sed 's,{{RCMAIL_DATA_DIR}},'"${RCMAIL_DATA_DIR}"',g' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's,{{RCMAIL_BACKUP_DIR}},'"${RCMAIL_BACKUP_DIR}"',g' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's,{{RCMAIL_REPOS_DIR}},'"${RCMAIL_REPOS_DIR}"',g' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's,{{RCMAIL_INSTALL_DIR}},'"${RCMAIL_INSTALL_DIR}"',g' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's,{{RCMAIL_SHELL_INSTALL_DIR}},'"${RCMAIL_SHELL_INSTALL_DIR}"',g' -i config/gitlab.yml

## configure gitlab
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_HOST}}/'"${RCMAIL_HOST}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_PORT}}/'"${RCMAIL_PORT}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_HTTPS}}/'"${RCMAIL_HTTPS}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_EMAIL}}/'"${RCMAIL_EMAIL}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_EMAIL_DISPLAY_NAME}}/'"${RCMAIL_EMAIL_DISPLAY_NAME}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_EMAIL_REPLY_TO}}/'"${RCMAIL_EMAIL_REPLY_TO}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_BACKUP_EXPIRY}}/'"${RCMAIL_BACKUP_EXPIRY}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_MAX_SIZE}}/'"${RCMAIL_MAX_SIZE}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_SSH_HOST}}/'"${RCMAIL_SSH_HOST}"'/' -i config/gitlab.yml
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_SSH_PORT}}/'"${RCMAIL_SSH_PORT}"'/' -i config/gitlab.yml

## configure default timezone
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_TIMEZONE}}/'"${RCMAIL_TIMEZONE}"'/' -i config/gitlab.yml

## configure mail delivery
#sudo -HEu ${RCMAIL_USER} sed 's/{{RCMAIL_EMAIL_ENABLED}}/'"${RCMAIL_EMAIL_ENABLED}"'/' -i config/gitlab.yml
#if [[ ${SMTP_ENABLED} == true ]]; then
  #sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_HOST}}/'"${SMTP_HOST}"'/' -i config/initializers/smtp_settings.rb
  #sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_PORT}}/'"${SMTP_PORT}"'/' -i config/initializers/smtp_settings.rb

  #case ${SMTP_USER} in
    #"") sudo -HEu ${RCMAIL_USER} sed '/{{SMTP_USER}}/d' -i config/initializers/smtp_settings.rb ;;
    #*) sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_USER}}/'"${SMTP_USER}"'/' -i config/initializers/smtp_settings.rb ;;
  #esac

  #case ${SMTP_PASS} in
    #"") sudo -HEu ${RCMAIL_USER} sed '/{{SMTP_PASS}}/d' -i config/initializers/smtp_settings.rb ;;
    #*) sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_PASS}}/'"${SMTP_PASS}"'/' -i config/initializers/smtp_settings.rb ;;
  #esac

  #sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_DOMAIN}}/'"${SMTP_DOMAIN}"'/' -i config/initializers/smtp_settings.rb
  #sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_STARTTLS}}/'"${SMTP_STARTTLS}"'/' -i config/initializers/smtp_settings.rb
  #sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_TLS}}/'"${SMTP_TLS}"'/' -i config/initializers/smtp_settings.rb
  #sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_OPENSSL_VERIFY_MODE}}/'"${SMTP_OPENSSL_VERIFY_MODE}"'/' -i config/initializers/smtp_settings.rb

  #case ${SMTP_AUTHENTICATION} in
    #"") sudo -HEu ${RCMAIL_USER} sed '/{{SMTP_AUTHENTICATION}}/d' -i config/initializers/smtp_settings.rb ;;
    #*) sudo -HEu ${RCMAIL_USER} sed 's/{{SMTP_AUTHENTICATION}}/'"${SMTP_AUTHENTICATION}"'/' -i config/initializers/smtp_settings.rb ;;
  #esac

  #if [[ ${SMTP_CA_ENABLED} == true ]]; then
    #if [[ -d ${SMTP_CA_PATH} ]]; then
      #sudo -HEu ${RCMAIL_USER} sed 's,{{SMTP_CA_PATH}},'"${SMTP_CA_PATH}"',' -i config/initializers/smtp_settings.rb
    #fi

    #if [[ -f ${SMTP_CA_FILE} ]]; then
      #sudo -HEu ${RCMAIL_USER} sed 's,{{SMTP_CA_FILE}},'"${SMTP_CA_FILE}"',' -i config/initializers/smtp_settings.rb
    #fi
  #else
    #sudo -HEu ${RCMAIL_USER} sed '/{{SMTP_CA_PATH}}/d' -i config/initializers/smtp_settings.rb
    #sudo -HEu ${RCMAIL_USER} sed '/{{SMTP_CA_FILE}}/d' -i config/initializers/smtp_settings.rb
  #fi
#fi

## configure nginx vhost
#sed 's,{{RCMAIL_INSTALL_DIR}},'"${RCMAIL_INSTALL_DIR}"',g' -i /etc/nginx/sites-enabled/gitlab
#sed 's,{{RCMAIL_LOG_DIR}},'"${RCMAIL_LOG_DIR}"',g' -i /etc/nginx/sites-enabled/gitlab
#sed 's/{{YOUR_SERVER_FQDN}}/'"${RCMAIL_HOST}"'/' -i /etc/nginx/sites-enabled/gitlab
#sed 's/{{RCMAIL_PORT}}/'"${RCMAIL_PORT}"'/' -i /etc/nginx/sites-enabled/gitlab
#sed 's,{{SSL_CERTIFICATE_PATH}},'"${SSL_CERTIFICATE_PATH}"',' -i /etc/nginx/sites-enabled/gitlab
#sed 's,{{SSL_KEY_PATH}},'"${SSL_KEY_PATH}"',' -i /etc/nginx/sites-enabled/gitlab
#sed 's,{{SSL_DHPARAM_PATH}},'"${SSL_DHPARAM_PATH}"',' -i /etc/nginx/sites-enabled/gitlab
#sed 's/{{SSL_VERIFY_CLIENT}}/'"${SSL_VERIFY_CLIENT}"'/' -i /etc/nginx/sites-enabled/gitlab
#if [[ -f ${CA_CERTIFICATES_PATH} ]]; then
  #sed 's,{{CA_CERTIFICATES_PATH}},'"${CA_CERTIFICATES_PATH}"',' -i /etc/nginx/sites-enabled/gitlab
#else
  #sed '/{{CA_CERTIFICATES_PATH}}/d' -i /etc/nginx/sites-enabled/gitlab
#fi

#if [[ ${RCMAIL_HTTPS_HSTS_ENABLED} == true ]]; then
#  sed 's/{{RCMAIL_HTTPS_HSTS_MAXAGE}}/'"${RCMAIL_HTTPS_HSTS_MAXAGE}"'/' -i /etc/nginx/sites-enabled/gitlab
#else
#  sed '/{{RCMAIL_HTTPS_HSTS_MAXAGE}}/d' -i /etc/nginx/sites-enabled/gitlab
#fi

appInit () {
  # due to the nature of docker and its use cases, we allow some time
  # for the database server to come online.
  case ${DB_TYPE} in
    mysql)
      prog="mysqladmin -h ${DB_HOST} -P ${DB_PORT} -u ${DB_USER} ${DB_PASS:+-p$DB_PASS} status"
      ;;
    pgsql)
      prog=$(find /usr/lib/postgresql/ -name pg_isready)
      prog="${prog} -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -t 1"
      ;;
    sqlite)
      ;;
    mssql)
      ;;
    sqlsrv)
      ;;
    oracle)
      ;;
  esac

  if [[ ${DB_TYPE} == sqlite ]]; then
    echo
  elif [[ ${DB_TYPE} == mssql ]]; then
    echo
  elif [[ ${DB_TYPE} == sqlsrv ]]; then
    echo
  else
    timeout=60
    printf "Waiting for database server to accept connections"
    while ! ${prog} >/dev/null 2>&1
    do
      timeout=$(expr $timeout - 1)
      if [[ $timeout -eq 0 ]]; then
        printf "\nCould not connect to database server. Aborting...\n"
        exit 1
      fi
      printf "."
      sleep 1
    done
    echo
  fi


  # run the `gitlab:setup` rake task if required
  case ${DB_TYPE} in
    mysql)
      QUERY="SELECT count(*) FROM information_schema.tables WHERE table_schema = '${DB_NAME}';"
      COUNT=$(mysql -h ${DB_HOST} -P ${DB_PORT} -u ${DB_USER} ${DB_PASS:+-p$DB_PASS} -ss -e "${QUERY}")
      ;;
    postgres)
      QUERY="SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';"
      COUNT=$(PGPASSWORD="${DB_PASS}" psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -Atw -c "${QUERY}")
      ;;
    sqlite)
      ;;
    mssql)
      ;;
    sqlsrv)
      ;;
  esac
  #if [[ -z ${COUNT} || ${COUNT} -eq 0 ]]; then
    #echo "Setting up GitLab for firstrun. Please be patient, this could take a while..."
    #sudo -HEu ${RCMAIL_USER} force=yes bundle exec rake gitlab:setup ${RCMAIL_ROOT_PASSWORD:+RCMAIL_ROOT_PASSWORD=$RCMAIL_ROOT_PASSWORD} >/dev/null
  #fi

}

appStart () {
    appInit

  ## start supervisord
  #echo "Starting supervisord..."
  #exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

    echo "Starting httpd..."
    source /etc/apache2/envvars
    chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} ${RCMAIL_DATA_DIR} ${RCMAIL_TEMP_DIR} ${RCMAIL_LOG_DIR}
    exec /usr/sbin/apache2 -DFOREGROUND
}

appHelp () {
  echo "Available options:"
  echo " app:start          - Starts the gitlab server (default)"
  echo " app:init             - Initialize the gitlab server (e.g. create databases, compile assets), but don't start it."
  echo " app:help           - Displays the help"
  echo " [command]      - Execute the specified linux command eg. bash."
}

case ${1} in
  app:start)
    appStart
    ;;
  app:init)
    appInit
    ;;
  app:help)
    appHelp
    ;;
  *)
    if [[ -x $1 ]]; then
      $1
    else
      prog=$(which $1)
      if [[ -n ${prog} ]] ; then
        shift 1
        $prog $@
      else
        appHelp
      fi
    fi
    ;;
esac

exit 0
