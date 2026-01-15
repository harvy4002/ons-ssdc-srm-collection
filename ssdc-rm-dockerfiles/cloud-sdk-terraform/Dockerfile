FROM google/cloud-sdk:slim

ARG TFENV_VERSION="v3.0.0"
ARG TERRAFORM_INITIAL_VERSION="1.7.2"

RUN apt-get update && \
    apt-get install google-cloud-cli-gke-gcloud-auth-plugin &&  `# GKE plugin needed for authentication` \
    apt-get install kubectl &&                                  `# kubectl` \
    apt-get install -y unzip &&                                 `# Tfenv depends on unzip` \
    rm -rf /var/lib/apt/lists/*                                 `# Remove package files to reduce image size bloat`

# Install tfenv from the github release tarball
# Configure tfenv to use gpgv (which is included in the cloud-sdk) for verification
# "trust-tfenv: yes" means tfenv will use its own packaged key for verification
RUN curl -L "https://github.com/tfutils/tfenv/archive/refs/tags/$TFENV_VERSION.tar.gz" -o "/home/cloudsdk/tfenv.tar.gz" && \
    mkdir "/home/cloudsdk/.tfenv" && \
    tar -xzf "/home/cloudsdk/tfenv.tar.gz" -C "/home/cloudsdk/.tfenv" --strip-components 1 && \
    rm "/home/cloudsdk/tfenv.tar.gz" && \
    echo 'trust-tfenv: yes' > "/home/cloudsdk/.tfenv/use-gpgv"
ENV PATH="/home/cloudsdk/.tfenv/bin:${PATH}"

# Install an initial version of terraform
RUN tfenv install "$TERRAFORM_INITIAL_VERSION" && \
    tfenv use "$TERRAFORM_INITIAL_VERSION"
