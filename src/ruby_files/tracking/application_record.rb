class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  after_update do |klass|
    ActiveRecord::Base.connection.execute("INSERT INTO tracking (table_name, action, object_id, changes) VALUES ('#{model.class.table_name}', 'UPDATE','#{model.id}', '#{model.saved_changes.to_json.gsub("'", %q(\\\')).gsub('\n','')}')")
  end
  after_create do |model|
    ActiveRecord::Base.connection.execute("INSERT INTO tracking (table_name, action, object_id, changes) VALUES ('#{model.class.table_name}', 'CREATE','#{model.id}', '#{model.to_json.gsub("'", %q(\\\')).gsub('\n','')}')")
  end
  after_destroy do |model|
    ActiveRecord::Base.connection.execute("INSERT INTO tracking (table_name, action, object_id, changes) VALUES ('#{model.class.table_name}', 'DESTROY','#{model.id}', '#{model.to_json.gsub("'", %q(\\\')).gsub('\n','')}')")
  end
end
