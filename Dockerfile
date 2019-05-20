FROM owasp/modsecurity:3-nginx
MAINTAINER Michael Tam michaeltam@sunnyvision.com

ARG COMMIT=v3.2/dev
ARG REPO=SpiderLabs/owasp-modsecurity-crs

ENV PARANOIA=1

RUN apt-get update && \
	apt-get -y install python git ca-certificates iproute2

RUN cd /opt && \
	git clone https://github.com/${REPO}.git owasp-modsecurity-crs && \
	cd owasp-modsecurity-crs && \
	git checkout -qf ${COMMIT}

RUN cd /opt/owasp-modsecurity-crs && \
	mkdir /etc/nginx/conf.d/modsecurity.d && \
	cp -R /opt/owasp-modsecurity-crs /etc/nginx/conf.d/modsecurity.d/owasp-crs/ && \
	mv crs-setup.conf.example /etc/nginx/conf.d/modsecurity.d/modsecurity.conf && \
	cd /etc/nginx/conf.d/modsecurity.d && \
	printf "include modsecurity.d/owasp-crs/modsecurity.conf\ninclude modsecurity.d/owasp-crs/rules/*.conf" > include.conf

