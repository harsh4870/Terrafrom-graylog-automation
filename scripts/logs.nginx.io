server
{
    server_name logs.graylog.test.com;

    location / {
      proxy_set_header Host $http_host;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Server $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Graylog-Server-URL http://$server_name;
      proxy_pass       http://127.0.0.1:9000;
    }

    listen 443 ssl; # managed by Certbot
    #ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem; # managed by Certbot
    #ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem; # managed by Certbot
    #include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    #ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    #ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem; # managed by Certbot
    #ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem; # managed by Certbot
}

server
{
	server_name logs.graylog.test.com;
    listen 80;

	location / {
      proxy_set_header Host $http_host;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Server $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Graylog-Server-URL http://$server_name;
      proxy_pass       http://127.0.0.1:9000;
    }
   
}


