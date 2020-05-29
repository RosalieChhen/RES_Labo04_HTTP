<?php
    $ip_dynamic = explode(";",getenv('DYNAMIC_IP'));
    $ip_static = explode(";", getenv('STATIC_IP'));
?>

<VirtualHost *:80>
    ServerName rorobastien.res.ch

    # ErrorLog ${APACHE_LOG_DIR}/error.log
    # CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Proxy balancer://dynamicCluster>
<?php for ($i = 0; $i < count($ip_dynamic); $i++)
    echo "      BalancerMember ". $ip_dynamic[$i] . "\n";
?>
    </Proxy>

    <Proxy balancer://staticCluster>
<?php for ($i = 0; $i < count($ip_static); $i++)
    echo "      BalancerMember ". $ip_static[$i] . "\n";
?>
    </Proxy>

    ProxyPreserveHost On

    ProxyPass "/api/employees/" "balancer://dynamicCluster/"
    ProxyPassReverse "/api/employees/" "balancer://dynamicCluster/"
    
    ProxyPass "/" "balancer://staticCluster/"
    ProxyPassReverse "/" "balancer://staticCluster/"

</VirtualHost>
