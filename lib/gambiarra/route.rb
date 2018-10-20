module Gambiarra
  class Route
    attr_reader :path, :view, :last
    attr_accessor :params

    def initialize(path, to:, with: {})
      @path   = path
      @view   = to
      @params = with
    end

    def respond(**other_params)
      view.respond(**params, **other_params)
    end
  end
end
