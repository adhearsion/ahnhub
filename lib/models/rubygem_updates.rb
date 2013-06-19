class RubygemUpdate < Sequel::Model
  many_to_one :rubygem

  class << self
    def handle_hook(payload)
      #TODO: Add or update a rubygem, as needed...
      #TODO: Add or update a plugin for that rubygem as needed
      #TODO: Save self
    end
  end
end