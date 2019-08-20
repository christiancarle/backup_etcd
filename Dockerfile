FROM k8s.gcr.io/etcd-amd64:3.2.18 
COPY run.sh /
ENV ETCDCTL_API=3
ENTRYPOINT ["/run.sh"]
