#!/bin/bash

#export os variables
export S3_URL=http://3.21.186.229:9000/bucket-teste
export S3_ACCESS_KEY=h76X1MDp4k
export S3_SECRET_KEY=hfX4nNSv9OMaN1MVZgmzE4mACkllC27k


#install Docker on Server
if [ `ps -eF | grep docker | grep -v grep | wc -l` == 0 ]; then
  apt install -y docker.io
fi


#run MinIO on Docker container and change secret and access key!
sleep 5
docker pull minio/minio
if [ `docker ps | grep minioServer | wc -l` != 1 ]; then
docker run -t -d -p 9000:9000 --name minioServer \
  -e "MINIO_ACCESS_KEY=$S3_ACCESS_KEY" \
  -e "MINIO_SECRET_KEY=$S3_SECRET_KEY" \
  -v /home/dev/mdata:/data \
  minio/minio server /data
fi


#create a bucket-teste if not exist
if [ `ls /home/dev/mdata/ | grep bucket-teste | wc -l` != 1 ]; then
  mkdir /home/dev/mdata/bucket-teste
fi


#install depencies to run python app
cd /home/$USER/app/python
apt install -y python3 python3-pip
pip3 install pipenv
pipenv --python 3 install --system --deploy


#kill gunicorn if run
pid=`ps ax | grep gunicorn | grep 5000 | awk '{split($0,a," "); print a[1]}' | head -n 1`
if [ -z "$pid" ]; then
  echo "no gunicorn up on port 5000"
else
  kill $pid
  echo "killed gunicorn on port 5000"
fi


#run the server
sleep 3
gunicorn --bind 0.0.0.0:5000 wsgi:app -D

exit 0
