FROM mongo:6.0.6

RUN ln -s /usr/bin/mongosh /usr/bin/mongo

ENTRYPOINT []

CMD ["mongod"]
