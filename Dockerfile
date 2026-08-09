# choose base image to build on
FROM python:3.11
# set working directory
WORKDIR /app
# copy Node package list
COPY package*.json .
# install packages
RUN npm install

# expose port 80 (SSL terminates on the ALB)
EXPOSE 80
# start application
CMD ["node", "app.js"]

