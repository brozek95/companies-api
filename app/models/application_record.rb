class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  DEFAULT_SQL_STRING_LENGTH = 255
end
