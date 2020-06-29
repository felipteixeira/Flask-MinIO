#!/bin/bash

#run MinIO on Docker container and change secret and access key!
docker pull minio/minio
docker run -t -d -p 9000:9000 --name minioServer \
  -e "MINIO_ACCESS_KEY=h76X1MDp4k" \
  -e "MINIO_SECRET_KEY=hfX4nNSv9OMaN1MVZgmzE4mACkllC27k" \
  -v /home/dev/mdata:/data \
  minio/minio server /data


#export os variables
export S3_URL=http://52.14.169.24:9000/bucket-teste
export S3_ACCESS_KEY=h76X1MDp4k
export S3_SECRET_KEY=hfX4nNSv9OMaN1MVZgmzE4mACkllC27k


#install depencies to run python app
cd /home/ubuntu/app/python
apt install -y python3 python3-pip
pip3 install pipenv
pipenv --python 3 install --system --deploy


#run the server
gunicorn --bind 0.0.0.0:5000 wsgi:app -D

exit 0
