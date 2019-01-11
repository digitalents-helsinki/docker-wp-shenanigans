FROM wordpress:latest
CMD ["mkdir", "wp-content/themes/digiloikka"]
ADD ./theme/ /var/www/html/wp-content/themes/digiloikka