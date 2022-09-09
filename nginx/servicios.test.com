server {
    listen 80;
    server_name	servicios.test.com;
    root /home/gnoss/docker_servicios_test/content;
	
    location /login/ {
        proxy_http_version 1.1;
	proxy_pass         http://127.0.0.1:8581/;
	proxy_cache_bypass $http_upgrade;
	proxy_set_header   Connection 'upgrade';
	proxy_set_header   Upgrade $http_upgrade;
    }
    location /facetas/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8582/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
    location /resultados/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8583/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
    location /interno/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8584/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
    location /archivo/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8585/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
    location /documents/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8586/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
	location /autocompletar/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8587/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
	location /oauth/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8590/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
	location /lucene_autocomplete/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8592/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
	location /autocompletaretiquetas/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8595/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
	location /lucene_api/ {
        proxy_http_version 1.1;
        proxy_pass         http://127.0.0.1:8596/;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   Connection 'upgrade';
        proxy_set_header   Upgrade $http_upgrade;
    }
}
