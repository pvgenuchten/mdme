FROM docker.io/debian:stable-slim  AS build
LABEL "author"="paul.vangenuchten@isric.org"

# See: https://www.kabisa.nl/tech/nvm-in-docker/
SHELL ["/bin/bash","-l","-c"]

#ARG NODE_ENV
ARG SG_ENV

# Set defaults for building (production)
ENV SG_ENV=${SG_ENV:-production}
 
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app
COPY . .

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN nvm install && nvm use

# install yarn 
RUN npm install --global yarn

# version and arg info, create .env for nodejs process.env
RUN echo -e "Implementing node: $(node --version)\nFrom: $(which node)"
RUN echo -e "Implementing node: $(yarn --version)\nFrom: $(which yarn)"
RUN echo -e "Implementing SG_ENV=$(echo $SG_ENV)"

# In case of problems (network) run yarn with --verbose
# New versions of yarn no longer have the problem
RUN yarn install  
RUN if [[ "$SG_ENV" == "develop" ]] ; \
        then echo "Running yarn build on develop mode" \
        && yarn build --verbose --mode=develop ; \
        else  echo "Running yarn on production mode" \
        && yarn build --verbose --mode=production ;  \
        fi


FROM docker.io/nginxinc/nginx-unprivileged:1.20.1-alpine@sha256:2262940b59e489bf4efb7fec12e2f6a19cb4b9561dc4650b11437dcaf4ed673d
LABEL "author"="paul.vangenuchten@isric.org"

COPY --from=build /app/dist /usr/share/nginx/html/
