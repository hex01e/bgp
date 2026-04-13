FROM frrouting/frr:v8.4.0

RUN sed -i -E 's/(bgpd|isisd|ospfd)(\s*=\s*)no/\1\2yes/' /etc/frr/daemons

