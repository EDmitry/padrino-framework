module Padrino
  module Generators
    module Components
      module Stylesheets
        module SassGen
          SASS_INIT = (<<-SASS).gsub(/^ {10}/, '')
            # Enables support for SASS template reloading for rack.
                # Store SASS files by default within 'app/stylesheets/sass'
                # See http://nex-3.com/posts/88-sass-supports-rack for more details.
                require 'sass/plugin/rack'
                Sass::Plugin.options[:template_location] = Padrino.root("app/stylesheets")
                Sass::Plugin.options[:css_location] = Padrino.root("public/stylesheets")
                app.use Sass::Plugin::Rack
          SASS

          def setup_stylesheet
            require_dependencies 'haml'
            initializer :sass, SASS_INIT
            empty_directory destination_root('/app/stylesheets')
          end
        end # SassGen
      end # Stylesheets
    end # Components
  end # Generators
end # Padrino