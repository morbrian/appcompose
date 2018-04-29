FROM morbrian/nginx-base

COPY certs/* /etc/nginx/certs/
COPY conf/* /opt/app-root/etc/nginx.d/

EXPOSE 18443

# inherited from nginx-base
# CMD /opt/rh/rh-nginx112/root/usr/sbin/nginx -g "daemon off;"
