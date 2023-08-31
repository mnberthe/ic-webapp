FROM python:3.6-alpine
MAINTAINER mnberthe15@gmail.com 
WORKDIR /opt
COPY app /opt
RUN pip install flask==1.1.2
EXPOSE 8080
ENV ODOO_URL="https://www.odoo.com/"
ENV PGADMIN_URL="https://www.pgadmin.org/"
ENTRYPOINT [ "python", "./app.py" ]
