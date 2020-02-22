class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  after_update do |model|
    add_entry(model.class.table_name, 'UPDATE', model.id, model.saved_changes.to_json.gsub("'", %q(\\\')).gsub('\n',''))
  end
  after_create do |model|
    add_entry(model.class.table_name, 'CREATE', model.id, model.to_json.gsub("'", %q(\\\')).gsub('\n',''))
  end
  after_destroy do |model|
    add_entry(model.class.table_name, 'DESTROY', model.id, model.to_json.gsub("'", %q(\\\')).gsub('\n',''))
  end

  def add_entry(model_name, action, model_id, changes)
    begin
      ActiveRecord::Base.connection.execute("INSERT INTO tracking (table_name, action, object_id, changes) VALUES ('#{model_name}', '#{action}' ,'#{model_id}', '#{changes}')")
    rescue
      ActiveRecord::Base.connection.execute("INSERT INTO tracking (table_name, action, object_id, changes) VALUES ('#{model_name}', '#{action}' ,'#{model_id}', '#{"ERROR PARSING".to_json}')")
    end
  end
end
