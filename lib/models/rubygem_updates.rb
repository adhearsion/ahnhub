class RubyGemUpdate < Sequel::Model
  many_to_one :plugins

  class << self
    def handle_hook(payload)
      #TODO: Add or update a plugin, as needed...
      #TODO: Save an instance of self based on the payload
    end
  end
end