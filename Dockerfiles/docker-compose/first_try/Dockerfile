FROM python:3.4-alpine
COPY ./app/* /code/
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "appSql.py"]

