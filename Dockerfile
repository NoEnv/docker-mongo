FROM mongo:8.0.10

RUN ln -s /usr/bin/mongosh /usr/bin/mongo

ENV GLIBC_TUNABLES=glibc.pthread.rseq=0

ENTRYPOINT []

CMD ["mongod"]
