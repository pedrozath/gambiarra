module Gambiarra
  module UI
    class CreateView < BaseView
      questions(view_name: {
        statement: 'Type the view name in a human way. Ex: "cook rice"' }
      )

      def render
        view = params[:view_name].gsub(/ |_|-/, '_').downcase
        thor.create_file("lib/#{project_name}/ui/views/#{view}.rb", <<~RUBY)
          module #{project_constant}
            module UI
              # you can also inherit from your other views, questions will be merged
              # assign them to nil to erase them
              class #{view.camelize} < BaseView
                questions({
                  question_name: {
                    statement: 'Welcome to #{project_name.titleize}',
                    options: ['exit'] # delete options to make this free form
                  }
                })
              end

              def render
                # might want render something here after questions are answered
              end
            end
          end

        RUBY
      end
    end
  end
end
