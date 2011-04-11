class User < ActiveRecord::Base
  validates_presence_of :name, :surname, :email, :password
  validates_format_of :email,
      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
      :message => ': Must be valid email.'
end
