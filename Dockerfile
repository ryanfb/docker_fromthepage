FROM phusion/passenger-ruby27
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# Install the Ubuntu packages.
# Install Ruby, RubyGems, Bundler, ImageMagick, MySQL and Git
# Install qt4/qtwebkit libraries for capybara
# Install build deps for gems installed by bundler
RUN add-apt-repository 'deb http://archive.ubuntu.com/ubuntu focal universe'
RUN apt-get update && apt-get install -y imagemagick libmagickwand-dev \
    git graphviz tzdata \
    build-essential && \
    apt-get install -y \
      $(apt-get -s build-dep ruby-rmagick | grep '^(Inst|Conf) ' | cut -d' ' -f2 | fgrep -v 'ruby') && \
    apt-get install -y \
      $(apt-get -s build-dep ruby-mysql2 | grep '^(Inst|Conf) ' | cut -d' ' -f2 | fgrep -v -e 'mysql-' -e 'ruby')

# Set the locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
WORKDIR /home

# Clone the repository
RUN git clone https://github.com/benwbrum/fromthepage.git
COPY database.sqlite.yml /home/fromthepage/config/database.sqlite.yml
COPY database.mysql.yml /home/fromthepage/config/database.mysql.yml

# Install required gems
#    bundle install
RUN gem install bundler
RUN cd fromthepage; bundle install; bundle add sqlite3
# RUN service mysql restart; ruby --version && mysql -V && false

# Configure MySQL

# Then update the config/database.yml file to point to the MySQL user account and database you created above.
# Run
#    rake db:migrate
# to load the schema definition into the database account.
# RUN find /var/lib/mysql -type f -exec touch {} \; && service mysql restart; cd fromthepage; bundle exec rake db:create; bundle exec rake db:migrate

# Finally, start the application
WORKDIR /home/fromthepage
EXPOSE 3000
ENV DATABASE_ADAPTER sqlite
VOLUME /data
# CMD find /var/lib/mysql -type f -exec touch {} \; && service mysql restart; cd fromthepage; bundle exec rails server
COPY fromthepage.sh /home/fromthepage/fromthepage.sh
CMD ./fromthepage.sh
