FROM mongo:8.0.0

RUN ln -s /usr/bin/mongosh /usr/bin/mongo

ENTRYPOINT []

CMD ["mongod"]
