# frozen_string_literal: true

module Gambiarra
  class App
    attr_reader :router, :debugging

    class << self
      attr_reader :app_class

      def inherited(app_class)
        @app_class = app_class
      end
    end

    def self.start(initial_route='')
      path, params = initial_route.split(' ').each_with_object([nil, {}]) do |segment, memo|
        if segment =~ /:/
          key, value = segment.split(':')
          memo[1].merge!([[key.to_sym, value.gsub('-', ' ')]].to_h)
        else
          memo[0] = [memo[0], segment].compact.join(' ')
        end
      end

      response = {path: (path || ''), **params}
      loop { response = app.flow(**response) }
    end

    def self.app
      @app ||= new
    end

    def initialize(debugging: false)
      debugging = true
      setup if respond_to?(:setup)
      @debugging = debugging
      @router = Router.new
    end

    def ask_questions(questions)
      questions.map { |name, question| [name, ask_question(question)] }.to_h
    end

    def ask_question(question)
      CLI::UI::Prompt.ask(question[:statement], options: question[:options])
    end

    def navigation(params)
      return {} if params.empty?
      CLI::UI::Prompt.ask('What to do now?') do |h|
        params.each do |key, _value|
          h.option("Different #{key}") { params[key] = nil }
        end
        h.option("Go back") { params[:path] = '' }
      end
      params
    end

    def output(response)
      return unless response[:content]
      puts [
        nil,
        "-> #{app_name} #{router.url}",
        nil,
        response[:content],
        nil
      ]
    end

    def app_name
      self.class.to_s.split('::').first.underscore.gsub('_', '-')
    end

    def flow(response)
      raise 'Response is empty' unless response
      output(response)
      response.delete(:content)
      questions = response&.delete(:questions) || {}
      response.merge!(navigation(response)) unless response.has_key?(:path) || questions.any?
      response.merge!(ask_questions(questions)) if questions.any?
      exit if response[:path] == 'exit'
      router.get(**response.compact)
    rescue => e
      puts e.backtrace if debugging
      puts e
      response.delete(:path)
      retry unless debugging
    end

    def exit
      Kernel.exit(0)
    end
  end
end
