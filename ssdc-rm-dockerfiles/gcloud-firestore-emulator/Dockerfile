FROM google/cloud-sdk:alpine
RUN apk --update add openjdk11-jre
RUN gcloud components install --quiet beta cloud-firestore-emulator

VOLUME /data 

EXPOSE 8540

CMD ["gcloud", "beta", "emulators", "firestore", "start", "--quiet", "--host-port=0.0.0.0:8540"]
