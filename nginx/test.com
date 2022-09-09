upstream test {
	server 127.0.0.1:8580;
}

server {
	listen 80;
	server_name test.com;
	root /home/gnoss/docker_test/content;
	
	location / {
		try_files $uri @test;
	}
	
	location @test {
		proxy_pass 		http://test;
		proxy_set_header 	X-Real-IP $remote_addr;
		proxy_set_header 	Host $host;
		proxy_set_header 	X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_http_version 	1.1;
		proxy_set_header 	Upgrade $http_upgrade;
		proxy_set_header 	Connection "upgrade";
		
		proxy_buffer_size          128k;
		proxy_buffers              4 256k;
		proxy_busy_buffers_size    256k;
	}
}
