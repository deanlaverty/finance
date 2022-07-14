FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www/html

USER $user


# FROM php:8.1-fpm-alpine3.15

# ARG user

# # run the following commands as root
# RUN \
#   # we should be creating scoped users in application Dockerfiles;
#   # we simply add and assume this user to ensure we're not running as root.
#   addgroup -S $user &&\
#   adduser -S -G $user $user www-data &&\
#   # ensure all packages are updated
#   apk update &&\
#   apk upgrade &&\
#   # install packages
#   apk --no-cache add git tzdata libpq build-base libzip libzip-dev libpng libpng-dev autoconf libmcrypt libmcrypt-dev icu icu-dev libxml2-dev libxslt libxslt-dev ca-certificates &&\
#   # install packages from edge repository (Until they have been created in main repository)
#   apk --no-cache add php81-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community &&\
#   # install php extensions
#   docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd &&\
#   pecl install -f mcrypt xmlrpc &&\
#   docker-php-ext-enable mcrypt &&\
#   # set timezone in London local time
#   cp /usr/share/zoneinfo/Europe/London /etc/localtime &&\
#   echo "Europe/London" > /etc/timezone &&\
#   # install composer
#   curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer --2 &&\
#   mkdir -p /var/www/html &&\
#   chown -R $user:$user /var/www/html &&\
#   # remove unused packages
#   apk del tzdata libpng-dev php81-dev build-base autoconf postgresql-dev icu-dev libmcrypt-dev libxml2-dev libxslt-dev libzip-dev &&\
#   # remove apk cache
#   rm -rf /var/cache/apk/*

# USER $user