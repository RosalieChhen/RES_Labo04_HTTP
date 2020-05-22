<?php
    $ip_static = getenv('STATIC_IP');
    $ip_dynamic = getenv('DYNAMIC_IP');
?>

<VirtualHost *:80>
    ServerName rorobastien.res.ch

    #ErrorLog ${APACHE_LOG_DIR}/error.log
    #CustomLog ${APACHE_LOG_DIR}/access.log combined

    ProxyPass '/api/employees/' 'http://<?php echo "$ip_dynamic" ?>/'
    ProxyPassReverse '/api/employees/' 'http://<?php echo "$ip_dynamic" ?>/'
    
    ProxyPass '/' 'http://<?php echo "$ip_static" ?>/'
    ProxyPassReverse '/' 'http://<?php echo "$ip_static" ?>/'

</VirtualHost>
