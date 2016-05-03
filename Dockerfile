FROM cimpress/git2consul:latest

COPY app.json /etc/git2consul.json

ENV CONSUL_ENDPOINT consul
ENV CONSUL_PORT 8500

CMD [ "node", "index.js", "--config-file", "/etc/git2consul.json" ]
