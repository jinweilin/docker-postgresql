FROM sameersbn/ubuntu:14.04.20151117
MAINTAINER sameer@damagehead.com

ENV PG_VERSION 9.4
RUN cp /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo 'Asia/Taipei' > /etc/timezone && date && \
		sed -e 's;UTC=yes;UTC=no;' -i /etc/default/rcS && \
		echo "!/bin/sh ntpdate ntp.ubuntu.com" >> /etc/cron.daily/ntpdate && \
		chmod 750 /etc/cron.daily/ntpdate && \
		wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
		echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
		apt-get update && \
		apt-get install -y postgresql-${PG_VERSION} postgresql-client-${PG_VERSION} postgresql-contrib-${PG_VERSION} pwgen && \
 		rm -rf /var/lib/postgresql && \
 		rm -rf /var/lib/apt/lists/* # 20150323 && \
 		apt-get clean

ADD start /start
RUN chmod 755 /start

EXPOSE 5432

VOLUME ["/var/lib/postgresql"]
VOLUME ["/run/postgresql"]

CMD ["/start"]
