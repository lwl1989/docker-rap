FROM codemix/yii2-base:2.0-php7-fpm

#RUN apt-get update \
#    && 
#   libfreetype6-dev \
#            libjpeg62-turbo-dev \
#            libmcrypt-dev \
#            libpng12-dev \
RUN apt-get update \
	&& apt-get -y install \
			git \
			nginx \
        --no-install-recommends \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-install iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
	&& cd /var/www/html \
	&& git clone https://gitee.com/gouguoyin/phprap.git /var/www/html -b "develop" \
	&& composer install 
	
ADD nginx.conf /etc/nginx/
