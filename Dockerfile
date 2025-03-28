FROM python:3.6-jessie #latest version

RUN apt-get update
RUN apt-get install -y supervisor

COPY ./src/ /home/src/
WORKDIR /home/src/

RUN pip3 install -r requirements.txt
#RUN pip3 install django-db-connection-pool[postgresql]==1.2.5
ENV REDISHOST=''
ENV REDISPORT=6379
ENV REDISDB=0

ENV MYSQL_DB='my_database'
ENV MYSQL_HOST='10.14.2.95'
ENV MYSQL_PORT='3306'
ENV MYSQL_USER='root'
ENV MYSQL_PWD='Root%401234'


ENV BROKER_URL="redis://localhost:6379/0" 
ENV CELERY_RESULT_BACKEND="redis://localhost:6379/0"


# celery -A celery_worker worker --loglevel=info
# celery -A celery_worker beat --loglevel=info
# uvicorn app:app --reload
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

#CMD  python3 manage.py runserver 0.0.0.0:8000
