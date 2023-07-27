# pull official base image
FROM node:16.15.1
# set working directory
WORKDIR /app
# add `/app/node_modules/.bin` to $PATH
#ENV PATH /node_modules/.bin:$PATH
# install app dependencies
COPY package.json /app
#COPY package-lock.json /app
COPY .npmrc /app
RUN npm install --legacy-peer-deps --force
RUN npm install -g @mobiscroll/cli
RUN mobiscroll config react --scss
# add app
COPY . /app
WORKDIR /app
# start app
CMD ["npm", "run", "local"]