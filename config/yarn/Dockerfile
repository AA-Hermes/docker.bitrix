FROM node:20.4.0

# Create app directory
WORKDIR "/var/www/bitrix"

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
RUN yarn cache clean
RUN yarn install
# If you are building your code for production
# RUN npm ci --omit=dev
#

CMD ["yarn", "build"]
#CMD ["tail", "-f", "/dev/null"]
