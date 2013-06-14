module Hexp
  class Node
    # Normalize a node
    #
    class Normalize
      # Set a node to be normalized
      #
      # @param [Array] node A non-strict hexp
      #
      # @example
      #     Hexp::Node::Normalize.new([:p, {class:'foo'}])
      #
      # @api public
      #
      def initialize(node)
        @raw = node
      end

      # Normalize to strict hexp nodes, cfr SPEC.md for details
      #
      # @return [Array] strict hexp node
      #
      # @api private
      #
      def call
        [@raw.first, normalized_attributes, normalized_children]
      end

      private

      # Pulls the attributes hash out of a non-strict hexp
      #
      # @return [Hash] the attributes hash
      #
      # @api private
      #
      def attributes
        attrs = @raw[1]
        return attrs if attrs.instance_of?(Hash)
        {}
      end

      def normalized_attributes
        Hash[*
          attributes.flat_map do |key, value|
            [key, value].map(&:to_s)
          end
        ]
      end

      # Pulls the children list out of a non-strict hexp
      #
      # @return [Array] the list of child hexps, non-strict
      #
      # @api private
      #
      def children
        @raw[1..2].each do |arg|
          return Array(arg) unless [Symbol, Hash].any?{|klz| arg.instance_of?(klz)}
        end
        []
      end

      # Normalize the third element of a hexp node, the list of children
      #
      # @return [Array] list of normalized hexps
      #
      # @api private
      #
      def normalized_children
        Hexp::List[*
          children.map do |child|
            case child
            when Hexp::Node
              child
            when String, TextNode
              Hexp::TextNode.new(child)
            when Array
              Hexp::Node[*child]
            else
              if child.respond_to? :to_hexp
                response = child.to_hexp
                raise FormatError, "to_hexp must return a Hexp::Node, got #{response.inspect}" unless response.instance_of?(Hexp::Node)
                response
              end
            end
          end
        ]
      end
    end

  end
end
