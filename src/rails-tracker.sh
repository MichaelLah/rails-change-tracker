#!/bin/zsh

#/Users/michaellah/Documents/GitHub/beam-api/app/models/application_record.rb
beam_api_dir='/Users/michaellah/Documents/GitHub/beam-api'
mysql_prefix="mysql -h 0.0.0.0 -P 3306 -u root -e"
#mysql_prefix2=$(mysql -h 0.0.0.0 -P 3306 -u root -e)
tracking_table="tracking"
currnet_db=$(head -n 1 $beam_api_dir/.development_mysql_override)

print_usage() {
  echo "lol git gud"
}

start_tracking() {
  cp ruby_files/tracking/application_record.rb $beam_api_dir/app/models/application_record.rb
  mysql -h 0.0.0.0 -P 3306 -u root -e "CREATE TABLE IF NOT EXISTS $currnet_db.$tracking_table (table_name varchar(60), object_id varchar(255), changes json)"
}
stop_tracking() {
  cp ruby_files/default/application_record.rb $beam_api_dir/app/models/application_record.rb
  mysql -h 0.0.0.0 -P 3306 -u root -e "DROP TABLE IF EXISTS $currnet_db.$tracking_table"
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
*)
  print_usage
  exit 1
  ;;
esac