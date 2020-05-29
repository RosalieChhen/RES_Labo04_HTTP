<?php
    $ip_static = getenv('STATIC_IP');
    $ip_dynamic = getenv('DYNAMIC_IP');
?>

<VirtualHost *:80>
    ServerName rorobastien.res.ch

    # ErrorLog ${APACHE_LOG_DIR}/error.log
    # CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Proxy balancer://dynamicCluster>
        BalancerMember http://172.17.0.7:3000
        BalancerMember http://172.17.0.6:3000
    </Proxy>

    <Proxy balancer://staticCluster>
        BalancerMember http://172.17.0.5:80
        BalancerMember http://172.17.0.4:80
        BalancerMember http://172.17.0.3:80
    </Proxy>

    ProxyPass '/' 'balancer://staticCluster/'
    ProxyPassReverse '/' 'balancer://staticCluster/'

    ProxyPass '/api/employees/' 'balancer://dynamicCluster/'
    ProxyPassReverse '/api/employees/' 'balancer://dynamicCluster/'

</VirtualHost>
