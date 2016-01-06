FROM python:2.7
 
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip  install -v -r   requirements.txt

COPY app.py /usr/src/app
CMD ["python", "app.py"]

