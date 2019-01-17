FROM wordpress:5.0.3-php7.3-apache

COPY ./theme /var/www/html/wp-content/themes/digiloikka
COPY ./gutenberg-blocks /var/www/html/wp-content/plugins/digiloikka-blocks
