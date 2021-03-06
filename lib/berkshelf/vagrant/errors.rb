require 'vagrant/errors'

module Berkshelf
  # A wrapper for a BerkshelfError for Vagrant. All Berkshelf exceptions should be
  # wrapped in this proxy object so they are properly handled when Vagrant encounters
  # an exception.
  #
  # @example wrapping an error encountered within the Vagrant plugin
  #   rescue BerkshelfError => e
  #     VagrantWrapperError.new(e)
  #   end
  class VagrantWrapperError < ::Vagrant::Errors::VagrantError
    # @param [BerkshelfError]
    attr_reader :original

    # @param [BerkshelfError] original
    def initialize(original)
      @original = original
    end

    def to_s
      "#{original.class}: #{original.to_s}"
    end

    private

      def method_missing(fun, *args, &block)
        original.send(fun, *args, &block)
      end
  end

  class BerksError < ::Vagrant::Errors::VagrantError
    attr_reader :error_message

    def initialize(message)
      @error_message = message
      super
    end
  end

  class BerksNotFound < ::Vagrant::Errors::VagrantError
    def error_message
      "Berks not found. Download the ChefDK from http://downloads.getchef.com/chef-dk and add it to your $PATH."
    end
  end

  class UnsupportedBerksVersion < ::Vagrant::Errors::VagrantError
    def initialize(bin, constraint, version)
      @bin        = bin
      @constraint = constraint
      @version    = version
      super
    end

    def error_message
      "Unsupported Berkshelf version at: #{@bin}. Requires #{@constraint} and got #{@version}." +
      " Download the latest version of the ChefDK from http://downloads.getchef.com/chef-dk and add it to your $PATH."
    end
  end

  class UnsupportedVagrantVersion < ::Vagrant::Errors::VagrantError
    def initialize(constraint)
      @constraint = constraint
      super
    end

    def error_message
      "vagrant-berkshelf requires Vagrant #{@constraint}."
    end
  end
end
