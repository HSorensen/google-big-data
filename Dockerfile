FROM alpine
LABEL name="alpine-python"
# Local 
#    Build: docker build -t itsme/alpine-python .  
#    Test:  docker run -it -v testui:/testui itsme/alpine-python
#    Versions: docker run -t itsme/alpine-python cat VERSIONS
# Remote
#    Login: docker login registry.TBD.com
#    Build: docker build -t registry.TBD .
#    Push:  docker push registry.TBD
# Use for Development, and local testing:
#    docker run -it --rm -v $PWD:/solutions-toolkit-talent -w /solutions-toolkit-talent --env-file .env itsme/alpine-python
#
#    docker build -t itsme/apline-linux . 
#    docker run -it --rm --env-file .env itsme/apline-linux

RUN apk update
RUN apk upgrade

RUN apk add --no-cache wget
RUN apk add --no-cache curl
RUN apk add --no-cache bash
RUN apk add --no-cache unzip
RUN apk add --no-cache tree

# Install python
RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev
RUN apk add --no-cache python3-dev
RUN apk add --no-cache py3-pip
RUN apk add --no-cache py3-wheel
RUN apk add --no-cache py3-matplotlib
RUN pip install faker
RUN pip install graphene
RUN pip install mypy
RUN pip install sortedcontainers

# Google-cloud-Talent
#RUN apk add --no-cache py3-grpcio
#RUN apk add --no-cache py3-yaml
#RUN pip install google-cloud-talent

# Google Cloud SDK
# ------------------------------------
# Note: the gcloud command is currently not needed, but here are the steps to install if needed
# From gcloud sdk https://cloud.google.com/sdk/docs/install
# https://cloud.google.com/storage/docs/gsutil_install#linux
# ----  ./install.sh --help
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-342.0.0-linux-x86_64.tar.gz
RUN tar xvf google-cloud-sdk-342.0.0-linux-x86_64.tar.gz
RUN echo "export PATH=$PATH:/google-cloud-sdk/bin" >/etc/profile.d/zGoogleCloudsdk.sh
RUN chmod +x /etc/profile.d/zGoogleCloudsdk.sh
RUN ./google-cloud-sdk/install.sh --path-update true --command-completion false --rc-path /etc/profile.d/zGoogleCloudsdk.sh --usage-reporting false
RUN ./etc/profile.d/zGoogleCloudsdk.sh
# gcloud init
# ------------------------------------

# Show version of critical components
RUN date > VERSIONS
RUN cat /etc/os-release  | grep PRETTY_NAME | cut -d '"' -f2 >> VERSIONS
RUN uname -a >> VERSIONS
RUN apk --version >> VERSIONS
RUN bash --version | head -n 1 >> VERSIONS
RUN gcc --version | head -n 1 >> VERSIONS
RUN python3 --version >> VERSIONS
RUN pip --version >> VERSIONS
RUN echo -n "faker, version " >> VERSIONS
RUN pip show faker | grep Version | cut -d ' ' -f2 >> VERSIONS
RUN echo -n "graphene, version " >> VERSIONS
RUN pip show graphene | grep Version | cut -d ' ' -f2 >> VERSIONS
RUN mypy --version >> VERSIONS
RUN apk list py3-matplotlib >> VERSIONS
# RUN apk list py3-grpcio >>VERSIONS
# RUN apk list py3-yaml >>VERSIONS
# RUN echo -n "google-cloud-talent, version " >> VERSIONS
# RUN pip show google-cloud-talent | grep Version | cut -d ' ' -f2 >> VERSIONS
RUN echo -n "google cloud SDK, version " >> VERSIONS
RUN /google-cloud-sdk/bin/gcloud --version | head -n 1 | cut -d ' ' -f4 >> VERSIONS
RUN echo -n "gsutil, version " >> VERSIONS
RUN /google-cloud-sdk/bin/gcloud --version | tail -n 1 | cut -d ' ' -f2 >> VERSIONS

# ------------------------------------
# Additional configuration of the environment. Note this assumes the ENV= is set. 
RUN cp /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh
# Note the ENV variable is read by the ash shell, and sourced as a profile.
# Look in /etc/profile and add custom config to /etc/profiles.d/*.sh. 
# ------------------------------------