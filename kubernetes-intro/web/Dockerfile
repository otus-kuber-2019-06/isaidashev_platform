FROM nginx
RUN usermod -u 1001 nginx && ln -s /usr/share/nginx/html /app 
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8000
