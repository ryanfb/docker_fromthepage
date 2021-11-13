#!/bin/bash

# remove SQLite-incompatible migrations
if [ "$DATABASE_ADAPTER" == "sqlite" ]; then
  rm -v db/migrate/037_pages_are_fulltext.rb \
        db/migrate/20130324195452_add_pages_xml_text_index_again.rb \
        db/migrate/20161004180158_remove_pages_xml_text_index.rb \
        db/migrate/20130324195315_remove_pages_xml_text_index_again.rb \
        db/migrate/20150115152502_add_search_text_to_page.rb \
        db/migrate/20140528213120_switch_collation_to_utf8.rb
else
  # hack to avoid racing MySQL server startup
  sleep 5
fi

cp -v config/database.$DATABASE_ADAPTER.yml config/database.yml && bundle exec rails db:prepare && bundle exec rails server -b 0.0.0.0
