module Gambiarra
  class View
    using Gambiarra::CoreExtensions

    attr_reader :params, :path

    class << self
      attr_reader   :descendants
      attr_accessor :parent

      def inherited(subclass)
        @descendants ||= {}
        subclass.parent = self
        new_descendant = { subclass.to_s.split('::').last.to_sym => subclass }
        @descendants.merge!(new_descendant)
        parent&.descendants&.merge!(new_descendant)
        @questions   ||= {}
        subclass.instance_variable_set(:@questions, @questions.deep_dup)
      end

      def questions(question_data)
        @questions.merge!(question_data)
        @questions.compact!
      end

      def set_path(value)
        @params[:path] = value
      end

      def respond(**params)
        remaining_questions = @questions.slice(*(@questions.keys - params.keys))
        return { questions: remaining_questions, **params } if remaining_questions.any?
        view = new(**params)
        { content: render(view), **params }
      end

      def render(view)
        view.render
      end
    end

    def initialize(**params)
      @params = params
    end

    def output(object)
      self.class.output(object)
    end

    def go_to(path, **params)
      # App.router.set_next(path, **params) and return
    end

    def ensure_param(param_name, &block)
      @params[param_name] = block.call if @params[param_name].nil?
    end
  end
end
