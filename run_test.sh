psql -f db/setup_test_db.sql postgres

bundle exec ruby test_app.rb

psql -f db/teardown_test_db.sql postgres
