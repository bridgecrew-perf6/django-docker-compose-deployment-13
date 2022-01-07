FROM python:3.10-alpine3.15
#LABEL maintainer="WWW.XYZ.COM"


ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
#copy django source code from app directory to app directory inside docker container
COPY ./app /app

#working container of new images should be in app directory
WORKDIR /app

#PORT 8000 USING TO DJANGO development server
EXPOSE 8000

#run python script in single comment because docker will create a image layer
#for each line of command .to reduce the image layer all it is best to all command will be in single line
#adduser --disabled-password --no-create-home app this line create a user,disabled password and donot create home directory for user
#username is app .if we dont add this line app run in root user.if app is compermised then they have access to full container(security)
#apk is alpin package manager used to install in alpine images
#chown -R app:app /vol && \ #this line change the owner of /vol directory to app user
#chmod -R 755 /vol && \ #this line to get  permission for read write delete
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /requirements.txt && \
    apk del .tmp-deps && \
    adduser --disabled-password --no-create-home app && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    chown -R app:app /vol && \
    chmod -R 755 /vol




#no need to specify full path.uses python inside venv 
ENV PATH="/py/bin:$PATH"


#swicths user from root user to app user.after this line only app user only run.(security)
USER app 

