FROM codemix/yii2-base:2.0-php7-fpm

#修改成163源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
	echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >/etc/apt/sources.list && \
	echo "deb http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
	echo "deb-src http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
	echo "deb-src http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list

#安装其他
RUN apt-get update \
        && apt-get -y install \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libmcrypt-dev \
            libpng12-dev \
            nginx \
        --no-install-recommends \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd
	
#下载源码并修改目录
RUN cd /var/www/html \
        && git clone https://gitee.com/gouguoyin/phprap.git  -b "develop" \
        && mv phprap/* ./ \
        && rm phprap -rf \
        && composer install \
		&& mkdir -p nginx \
        && chown www-data:www-data -R /var/www/html 
		
ADD nginx.conf /var/www/html/nginx/

EXPOSE 80
EXPOSE 9000

CMD ["nginx","-c","/var/www/html/nginx/nginx.conf"]