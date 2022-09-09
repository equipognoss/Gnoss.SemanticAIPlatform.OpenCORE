upstream api {
	server 127.0.0.1:8589;
}

server {
	listen 80;
	server_name api.test.com;
	
	root /home/gnoss/docker_test/content;
	
	location / {
		try_files $uri @api;
	}
	
	location @api {
		proxy_pass 		http://api;
		proxy_set_header	X-Real-IP $remote_addr;
		proxy_set_header	Host $host;
		proxy_set_header	X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_http_version	1.1;
		proxy_set_header	Upgrade $http_upgrade;
		proxy_set_header	Connection "upgrade";
	}
}
