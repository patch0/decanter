require 'active_support/all'

module Decanter

  class << self

    def decanter_for(klass_or_sym)
      case klass_or_sym
      when Class
        klass_or_sym.name
      when Symbol
        klass_or_sym.to_s.singularize.camelize
      else
        raise ArgumentError.new("cannot lookup decanter for #{klass_or_sym} with class #{klass_or_sym.class}")
      end.concat('Decanter').constantize
    end

    def decanter_from(klass_or_string)
      constant =
        case klass_or_string
        when Class
          klass_or_string
        when String
          klass_or_string.constantize
        else
          raise ArgumentError.new("cannot find decanter from #{klass_or_string} with class #{klass_or_string.class}")
        end

      unless constant.ancestors.include? Decanter::Base
        raise ArgumentError.new("#{constant.name} is not a decanter")
      end

      constant
    end
  end

  ActiveSupport.run_load_hooks(:decanter, self)
end

Dir["#{File.dirname(__FILE__)}/decanter/*.rb"].each { |f| require f }

if defined?(::Rails)
  Dir["#{File.dirname(__FILE__)}/decanter/rails/*.rb"].each { |f| require f }
end
