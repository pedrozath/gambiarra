module Gambiarra
  module UI
    class Install < BaseView
      questions({
        confirm_installation: {
          statement: 'It will install Gambiarra on current folder. Are you sure?',
          options: [
            'yes',
            'exit'
          ]
        }
      })

      def render
        exit if params[:confirm_installation] == 'exit'
        thor.empty_directory("lib/#{project_name}/ui/views")
        thor.create_file("lib/#{project_name}/ui.rb", <<~RUBY)
          require('gambiarra')
          require File.expand_path('../ui/base_view', __FILE__)
          views = Dir[File.expand_path('../ui/views/*', __FILE__)].each do |view|
            require(view)
          end

        RUBY

        thor.create_file("lib/#{project_name}/ui/base_view.rb", <<~RUBY)
          module #{project_constant}
            module UI
              class BaseView < Gambiarra::View
                def render(view)
                  view.render
                end
              end
            end
          end

        RUBY

        thor.create_file("lib/#{project_name}/ui/views/index.rb", <<~RUBY)
          module #{project_constant}
            module UI
              class Index < BaseView
                questions({
                  path: {
                    statement: 'Welcome to #{project_name.titleize}',
                    options: [
                      'an option',
                      'exit'
                    ]
                  }
                })
              end
            end
          end

        RUBY

        thor.create_file("exe/#{project_name.gsub('_', '-')}", <<~RUBY)
          #!/usr/bin/env ruby
          # frozen_string_literal: true
          $LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

          require '#{project_name}/ui'

          module #{project_constant}
            module UI
              class App < Gambiarra::App
                def setup
                  # you can setup stuff here
                end
              end
            end
          end

          #{project_constant}::UI::App.start(ARGV.join(' '))

        RUBY


        thor.chmod("exe/#{project_name.gsub('_', '-')}", '+x')

        "Installed Gambiarra in #{Dir.pwd}"
      end
    end
  end
end
