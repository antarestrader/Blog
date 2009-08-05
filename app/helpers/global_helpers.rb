module Merb
  module GlobalHelpers
    def local_time(utc)
      TZInfo::Timezone.get('America/Los_Angeles').utc_to_local(utc)
    end
    
    def time_zone
      TZInfo::Timezone.get('America/Los_Angeles').current_period.abbreviation.to_s
    end
  end
end
