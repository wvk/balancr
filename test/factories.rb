Factory.define :user do |f|
  f.login 'test'
end

Factory.define :project do |f|
  f.name 'test project'
end

Factory.define :expense do |f|
  f.association :project,
      :factory => :project
  f.association :user,
      :factory => :user
  f.amount 42
end

Factory.define :payment do |f|
  f.association :debitor_user,
      :factory => :user
  f.association :creditor_user,
      :factory => :user
  f.amount 42
end

Factory.define :membership do |f|
  f.association :project,
      :factory => :project
  f.association :user,
      :factory => :user
end

