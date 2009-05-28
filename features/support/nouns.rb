require File.dirname(__FILE__) + '/env.rb'
module NounForms
  #NOUN_FORMS = '((?:that|those) \w*|the \d+(?:st|nd|rd|th) \w*?|it|I|me|".+?"|the \w* named ".*?")'
  def is
    '(?:is|are|am)'
  end
  
  def noun(set = :all)
    '((?:that|those) \w*|the \d+(?:st|nd|rd|th) \w*?|it|I|me|".+?"|the \w* named ".*?")'
  end
  
  def get_noun(noun)
    case noun
      when /"(.*)"/
        @_labels[$1]
      when /(?:that|those) (\w*)/
        instance_variable_get "@#{$1}"
      when /the (\d+)(?:st|nd|rd|th) (\w*)/
        instance_variable_set "@#{$2}",(instance_variable_get "@#{$2.pluralize}")[$1.to_i - 1]
      when "it"
        @it
      when "I","me"
        @me
      when /the (\w*) named "(.*)"/
        #todo Check this
        instance_variable_set "@#{$1}",(Object.const_get($1.capitalize).get(:first, :name=>$2))
    end
  end
end #module NounForms

def is
  '(?:is|are|am)'
end

def noun(set = :all)
  '((?:that|those) \w*|the \d+(?:st|nd|rd|th) \w*?|it|I|me|".+?"|the \w* named ".*?")'
end

World(NounForms)
puts "~ Nouns Support enabled"