# Google Cloud Pub/Sub Documentation
# https://cloud.google.com/pubsub/docs/

FROM google/cloud-sdk:alpine
RUN apk --update add openjdk11-jre
RUN gcloud components install --quiet beta pubsub-emulator

VOLUME /data 

EXPOSE 8538

CMD ["gcloud", "beta", "emulators", "pubsub", "start", "--quiet",  "--data-dir=/data", "--host-port=0.0.0.0:8538"]
