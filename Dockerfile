FROM ubuntu as build
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init
RUN apt-get install wget -y
RUN apt-get install xz-utils -y
RUN apt-get install git -y
RUN apt-get install sudo -y
RUN adduser --home /home/flutter flutter
RUN adduser flutter sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER flutter
WORKDIR /home/flutter/app
RUN mkdir /home/flutter/Downloads
RUN mkdir /home/flutter/development
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.4-stable.tar.xz -P /home/flutter/Downloads
RUN cd /home/flutter/development && tar xf /home/flutter/Downloads/flutter_linux_3.13.4-stable.tar.xz
RUN sudo git config --system --add safe.directory '*'

COPY --chown=flutter . .
RUN /home/flutter/development/flutter/bin/flutter build web

FROM nginx
COPY --from=build /home/flutter/app/build/web /usr/share/nginx/html