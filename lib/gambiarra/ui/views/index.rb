module Gambiarra
  module UI
    class Index < BaseView
      questions({
        path: {
          statement: "Welcome to Gambiarra #{Gambiarra::VERSION}",
          options: [
            'install',
            'create view',
            'exit'
          ]
        }
      })
    end
  end
end
