RSpec.describe Gambiarra::App do
  let(:app) { DummyApp::UI::App.new(debugging: true) }

  it 'calls the correct view with the given path' do
    expect(app.flow(path: 'hello world'))
      .to include(content: 'Hello World')
  end

  it 'gets needed questions' do
    expect(app.flow(path: '')).to(
      include(
        questions: {
          path: {
            statement: 'Where to go?',
            options: ['hello world']
          }
        }
      )
    )
  end
end
