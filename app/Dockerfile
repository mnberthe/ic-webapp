FROM python:3.6-alpine
MAINTAINER mnberthe15@gmail.com 
WORKDIR /opt
COPY app /opt
RUN pip install flask==1.1.2
EXPOSE 8080
ARG ODOO_URL
ARG PGADMIN_URL
ENV ODOO_URL=$ODOO_URL
ENV PGADMIN_URL=$PGADMIN_URL
ENTRYPOINT [ "python", "./app.py" ]
#docker run -p 8080:8080  -e "ODOO_URL= https://www.odoo.com/" -e "PGADMIN_URL= https://www.pgadmin.org/" ic-webapp:1.0 