FROM ubuntu:20.10

RUN mkdir -p /usr/share/application

#ENV HOME=/usr/share/application
#ENV APP_HOME=/usr/share/application/django

#RUN mkdir -p $APP_HOME

#WORKDIR $APP_HOME

#ENV PYTHONDONTWRITEBYTECODE 1
#ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND=noninteractive

# install psycopg2 dependencies
#RUN apt-get -y update && apt-get -y install gcc python3 python3-dev python3-pip libmariadb-dev-compat libmariadb-dev libmariadbd-dev libmariadb-dev curl telnet

RUN apt-get -y update && apt-get -y install nginx curl telnet

# set your timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

#RUN pip install --upgrade pip

#COPY requirements.txt $APP_HOME
#COPY startgunicorn.sh $APP_HOME
#COPY stopgunicorn.sh $APP_HOME
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig && mkdir -p /var/www/html/static

COPY nginx.conf /etc/nginx/nginx.conf
COPY static.conf /etc/nginx/conf.d/
COPY nginx.sh /usr/local/bin/
COPY index.html /var/www/html/
#RUN pip install -r requirements.txt

#COPY covid19_django/ $APP_HOME/
COPY static/ /var/www/html/static/
#COPY covid19docker/ $APP_HOME/

RUN chmod a+x /usr/local/bin/nginx.sh && chown -R www-data:www-data /var/www/html/

#USER covid19

EXPOSE 80

#ENV PATH /usr/share/application/django/:$PATH

#ENTRYPOINT startgunicorn.sh

#CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "--daemon", "covid19docker.wsgi"]
CMD /usr/local/bin/nginx.sh

