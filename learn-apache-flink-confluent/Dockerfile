# extend from confluent-cli
FROM confluentinc/confluent-cli:4.43.0

# Switch to root temporarily to install python
USER root

# Install python
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python

# Switch back to user `confluent`
USER confluent

# Install plugin confluent-flink
RUN confluent plugin install confluent-flink-quickstart

