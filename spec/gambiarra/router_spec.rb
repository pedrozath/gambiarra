RSpec.describe Gambiarra::App do
  let(:router) { Gambiarra::Router.new }

  it 'draws routes based on view files' do
    expect(router.routes.map { |r| r.path }).to include('', 'hello world')
  end

end
