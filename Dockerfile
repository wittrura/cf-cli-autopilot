FROM ubuntu:xenial
LABEL maintainer "🐨"

RUN sed -i s!http://archive.ubuntu.com/ubuntu/!http://dcsartifacts.dell.com/artifactory/ubuntu-main!g /etc/apt/sources.list
RUN sed -i s!http://security.ubuntu.com/ubuntu/!http://dcsartifacts.dell.com/artifactory/ubuntu-security!g /etc/apt/sources.list

RUN apt-get update && apt-get install -y wget apt-transport-https
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get update && apt-get install -y cf-cli

RUN wget -q -O /tmp/autopilot-linux https://github.com/contraband/autopilot/releases/download/0.0.6/autopilot-linux
RUN chmod +x /tmp/autopilot-linux && cf install-plugin /tmp/autopilot-linux -f && rm -f /tmp/autopilot-linux

# Add log testing script
COPY check-cf-logs /usr/local/bin/
RUN chmod 500 /usr/local/bin/check-cf-logs
