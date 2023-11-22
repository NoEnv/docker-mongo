FROM mongo:7.0.3

RUN ln -s /usr/bin/mongosh /usr/bin/mongo

ENTRYPOINT []

CMD ["mongod"]
