class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  after_commit do |klass|
    ActiveRecord::Base.connection.execute("INSERT INTO tracking VALUES ('#{klass.class.table_name}', '#{klass.id}', '#{klass.saved_changes.to_json}')")
  end
end
