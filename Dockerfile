FROM python:3.9-alpine3.13
LABEL maintainer="samiullahoffice0"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./requirements.dev.txt /requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000


ARG DEV=false
RUN pip install --upgrade pip
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps build-base postgresql-dev musl-dev
RUN pip install -r /requirements.txt
RUN \
if [ $DEV = "true" ]; \
    then pip install -r /requirements.dev.txt ; \
fi
RUN rm -rf /mp-build-deps
RUN adduser --disabled-password --no-create-home django-user
ENV PATH="/py/bin:$PATH"
USER django-user