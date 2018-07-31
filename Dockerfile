FROM phusion/passenger-ruby23
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# Install the Ubuntu packages.
# Install Ruby, RubyGems, Bundler, ImageMagick, MySQL and Git
# Install qt4/qtwebkit libraries for capybara
# Install build deps for gems installed by bundler
RUN add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
RUN apt-get update && apt-get install -y imagemagick libmagickwand-dev \
    mysql-server-5.6 mysql-client-5.6 git graphviz tzdata \
    libqt4-dev libqtwebkit-dev build-essential && \
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

# Install required gems
#    bundle install
RUN gem install bundler
RUN cd fromthepage; bundle install
# RUN service mysql restart; ruby --version && mysql -V && false

# Configure MySQL
# Create a database and user account for FromThePage to use.
# Then update the config/database.yml file to point to the MySQL user account and database you created above.
# Run
#    rake db:migrate
# to load the schema definition into the database account.
RUN service mysql restart; cd fromthepage; bundle exec rake db:create; bundle exec rake db:migrate

# Finally, start the application
EXPOSE 3000
CMD service mysql restart; cd fromthepage; bundle exec rails server
