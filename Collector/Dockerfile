FROM python:3-alpine

WORKDIR app
ADD collector.py /app

RUN pip install mysql-connector-python

CMD [ "python", "./collector.py" ]
