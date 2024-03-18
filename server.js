http {
    upstream websocket {
        server webserver1.example.com;
        server webserver2.example.com;
    }

    server {
        listen 8056;

        location / {
            proxy_pass http://websocket;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
        }
    }
}