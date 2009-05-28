Factory.define :user do |f|
  f.sequence(:login){|n| "User-#{n}"}
  f.password  "password"
  f.password_confirmation {|u| u.password}
end

Factory.define :author, :parent=>:user do |f|
  
end

Factory.define :post do |f|
  f.sequence(:title){|n| "Post-#{n}"}
  f.text <<-LorimIpsom
#Factory Girl  

factory_girl is a fixtures replacement with a straightforward definition
syntax, support for multiple build strategies (saved instances, unsaved
instances, attribute hashes, and stubbed objects), and support for multiple
factories for the same class (user, admin_user, and so on), including
factory inheritence.

-----

It is highly recommended that you have one factory for each class that
provides the simplest set of attributes necessary to create an instance of
that class. If you're creating ActiveRecord objects, that means that you
should only provide attributes that are required through validations and
that do not have defaults. Other factories can be created through inheritence
to cover common scenarios for each class. 
LorimIpsom
  
end

Factory.define :published_post, :parent=>:post do |f|
  f.published_at Time.now
end
