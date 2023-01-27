FROM    nginx
COPY    index.html /usr/share/nginx/html
COPY    components.html /usr/share/nginx/html
ADD     assets /usr/share/nginx/html/assets

