FROM alpine:3.9
LABEL maintainer="@christiancarle (github.com/christiancarle)"
RUN apk add --no-cache curl \
&& mkdir -p /tmp/etcd \
&& curl -L https://storage.googleapis.com/etcd/v3.3.15/etcd-v3.3.15-linux-amd64.tar.gz -o /tmp/etcd-v3.3.15-linux-amd64.tar.gz \
&& tar xzvf /tmp/etcd-v3.3.15-linux-amd64.tar.gz -C /tmp/etcd --strip-components=1
ENV ETCDCTL_API=3
COPY run.sh /
ENTRYPOINT ["/run.sh"]
