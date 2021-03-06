# require tilt if available; fall back on bundled version.
begin
  require 'tilt'
rescue LoadError
  require 'sinatra/tilt'
end
require 'padrino-core/support_lite'
require 'mail'

# Require respecting order our dependencies
Dir[File.dirname(__FILE__) + '/padrino-mailer/**/*.rb'].each {|file| require file }

module Padrino
  ##
  # This component uses the 'mail' library to create a powerful but simple mailer system within Padrino (and Sinatra).
  # There is full support for using plain or html content types as well as for attaching files.
  # The MailerPlugin has many similarities to ActionMailer but is much lighterweight and (arguably) easier to use.
  #
  module Mailer
    ##
    # Register
    #
    #   Padrino::Mailer::Helpers
    #
    # for Padrino::Application
    #
    class << self
      def registered(app)
        app.helpers Padrino::Mailer::Helpers
      end
      alias :included :registered
    end
  end # Mailer
end # Padrino