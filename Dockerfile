# Stage 1: Build the static site with Jekyll
FROM ruby:3.3 as builder

# Install Jekyll and Bundler
RUN gem install bundler

# Set the working directory
WORKDIR /site

# Copy Jekyll configuration and site files
COPY . .

# Install dependencies and build the site

# Set env variables
ENV PAGES_REPO_NWO=yulinhuang/playground-runner

RUN bundle init && \
    # echo "gem 'jekyll'" >> Gemfile && \
    # echo "gem 'minima'" >> Gemfile && \
    echo "gem 'github-pages', group: :jekyll_plugins" >> Gemfile && \
    bundle install && \
    jekyll build --destination /site/dist

# Stage 2: Serve the static website with Nginx
FROM nginx:alpine

# Copy the built static site to Nginx's default html directory
COPY --from=builder /site/dist /usr/share/nginx/html

# Expose the web server port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]