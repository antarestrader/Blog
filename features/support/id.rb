module IDForms
  def id_selector(inst)
    "##{[inst.class.to_s.underscore,inst.id].join '_'}"
  end
end
World(IDForms)
puts "~ id support enabled"