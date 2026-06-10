# Use official PHP image with necessary extensions for Laravel
FROM php:8.4-fpm

# Set timezone
ENV TZ=UTC

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libicu-dev \
    g++ \
    cron \
    chromium \
    libpq-dev \
    postgresql \
    postgresql-contrib \
    libexif-dev \
    supervisor \
    default-mysql-client \
    default-libmysqlclient-dev \
    libx11-xcb1 \
    libxcomposite1 \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libxcb1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pgsql --with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    mysqli \
    pdo_pgsql \
    pgsql \
    gd \
    zip \
    bcmath \
    intl \
    opcache \
    mbstring \
    xml \
    exif \
    sockets \
    pcntl \
    && pecl install redis \
    && docker-php-ext-enable redis

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js and npm, then pnpm
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g pnpm puppeteer

# Set working directory
WORKDIR /var/www/html

# --- FIXED: Copy code from the local src folder into the container ---
COPY ./src /var/www/html

# --- FIXED: Temporarily comment out these production build steps for smooth local runtime ---
# RUN composer install --optimize-autoloader --no-dev
# RUN php artisan storage:link
# RUN php artisan ziggy:generate
# RUN pnpm install
# RUN pnpm build

# Set proper permissions for www-data
RUN chown -R www-data:www-data /var/www/html

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM directly instead of supervisor for now
CMD ["php-fpm"]