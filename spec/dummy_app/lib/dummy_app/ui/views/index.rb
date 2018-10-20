module DummyApp
  module UI
    class Index < BaseView
      questions({
        path: {
          statement: 'Where to go?',
          options: ['hello world']
        }
      })
    end
  end
end
