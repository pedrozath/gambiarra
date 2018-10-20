module Gambiarra
  class Router
    attr_reader :path, :params, :routes, :history, :url

    def initialize
      @routes  = []
      @history = History.new

      base_view = View.descendants[:BaseView]
      draw_route '', to: base_view.descendants[:Index]
      base_view.descendants.each do |name, view|
        next if name == :Index
        draw_route name.to_s.underscore.humanize.downcase, to: view
      end
    end

    def get(**params)
      path = params.delete(:path)
      @url  = build_url(path || history.current_route.path, **params)
      route = routes.detect { |route| route.path == path }
      return history.refresh(params) unless route
      history.add(route)
      route.respond(**params)
    end

    def previous_path
      history.previous
    end

    private

    def build_url(path, params)
      [
        path,
        (params || {}).map do |k,v|
          [k,v.gsub(' ', '-')].join(':')
        end
      ].compact.join(' ')
    end

    def draw_route(*args, **keyword_args, &block)
      @routes << Route.new(*args, **keyword_args, &block)
    end
  end
end
