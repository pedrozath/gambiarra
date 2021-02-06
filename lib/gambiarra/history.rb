module Gambiarra
  class History
    attr_reader :routes

    def initialize
      @routes = []
    end

    def add(route)
      @routes << route
    end

    def previous
      routes[-2]&.path || ''
    end

    def current_route
      routes[-1]
    end

    def back
      routes.pop.respond
    end

    def refresh(**params)
      return {
        content: 'Abnormal end',
        path: 'exit'
      } unless current_route

      current_route.respond(**params)
    end
  end
end
