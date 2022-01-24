#updated file
FROM ubuntu 
MAINTAINER shridhanr@gmail.com 

RUN apt-get update -y
RUN apt-get install –y nginx 
CMD [“echo”,”Nginx Image created”] 
