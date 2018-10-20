module Gambiarra
  module CoreExtensions
    refine Hash do
      def deep_dup
        dup_hash = {}
        each { |k, v| dup_hash[k] = v.is_a?(Hash) ? v.deep_dup : v.dup }
        dup_hash
      end
    end
  end
end
