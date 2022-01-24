FROM ubuntu 
MAINTAINER shridhanr@gmail.com 

RUN apt-get update 
RUN apt-get install –y nginx 
CMD [“echo”,”Nginx Image created”] 
