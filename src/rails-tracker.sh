#!/bin/zsh

#/Users/michaellah/Documents/GitHub/beam-api/app/models/application_record.rb
beam_api_dir='/Users/michaellah/Documents/GitHub/beam-api'
tracker_dir='/Users/michaellah/Documents/GitHub/rails-change-tracker'
mysql_prefix="mysql -h 0.0.0.0 -P 3306 -u root -e"
#mysql_prefix2=$(mysql -h 0.0.0.0 -P 3306 -u root -e)
tracking_table="tracking"
currnet_db=$(head -n 1 $beam_api_dir/.development_mysql_override)

rails_path_file=config/rails_path.txt
tracker_path_file=config/tracker_path.txt

print_usage() {
  echo "Usage:"
  echo "rails-tracker.sh init - setup the tracker for use"
  echo "rails-tracker.sh start - Create a tracking table and start tracking all active record changes"
  echo "rails-tracker.sh stop - Drop tracking table and stop tracking changes"
}

start_tracking() {
  echo "replacing application_record.rb"
  cp $tracker_dir/src/ruby_files/tracking/application_record.rb $beam_api_dir/app/models/application_record.rb
  echo "creating tracking table."
  mysql -h 0.0.0.0 -P 3306 -u root -e "CREATE TABLE IF NOT EXISTS $currnet_db.$tracking_table (id int NOT NULL AUTO_INCREMENT, table_name varchar(60), action varchar(20) ,object_id varchar(255), changes json, PRIMARY KEY (id))"
}
stop_tracking() {
  echo "resetting application_record.rb"
  cp $tracker_dir/src/ruby_files/default/application_record.rb $beam_api_dir/app/models/application_record.rb
  echo "dropping tracking table"
  mysql -h 0.0.0.0 -P 3306 -u root -e "DROP TABLE IF EXISTS $currnet_db.$tracking_table"
}

reset_tracking() {
  echo "clearning tracking table."
  mysql -h 0.0.0.0 -P 3306 -u root -e "TRUNCATE TABLE $currnet_db.$tracking_table"
}

init() {
  # setup beam-api location
  if [ ! -f "$rails_path_file" ]; then
    touch "$rails_path_file"
  fi 
  echo "Enter path of your beam-api folder\n"
  read response
  echo $response > $rails_path_file

  # setup tracker location
  if [ ! -f "$tracker_path_file" ]; then
    touch "$tracker_path_file"
  fi 
  echo "Enter path of your tracker folder\n"
  read response
  echo $response > $tracker_path_file
  echo "finished! Try: \n\n ./rails-tracker.sh start\n\nTo start tracking active record changes."
}
#echo $currnet_db
#stop_tracking
#start_tracking

case $1 in
"start")
  echo "starting tracking on $currnet_db"
  start_tracking
  ;;
"stop")
  stop_tracking
  ;;
"reset")
  reset_tracking
  ;;
"init")
  init
  ;;
*)
  print_usage
  exit 1
  ;;
esac