module SmartAnswer
  class Group < Node    
                    
    def initialize(name, options = {}, &block)
      @name = name
      @nodes = []
      @state = nil
      instance_eval(&block) if block_given?
    end                       

    def multiple_choice(name, options = {}, &block)
      add_node Question::MultipleChoice.new(name, options, &block)
    end

    def date_question(name, &block)
      add_node Question::Date.new(name, &block)
    end

    def value_question(name, &block)
      add_node Question::Value.new(name, &block)
    end

    def money_question(name, &block)
      add_node Question::Money.new(name, &block)
    end

    def salary_question(name, &block)
      add_node Question::Salary.new(name, &block)
    end

    def questions
      @nodes.select { |n| n.is_a?(Question::Base) }
    end     

    def node_exists?(node_or_name)
      @nodes.any? {|n| n.name == node_or_name.to_sym }
    end

    def node(node_or_name)
      @nodes.find {|n| n.name == node_or_name.to_sym } or raise "Node '#{node_or_name}' does not exist"
    end

    def start_state
      State.new(questions.first.name).freeze
    end

    def process(responses)
      responses.inject(start_state) do |state, response|
        return state if state.error
        begin
          node(state.current_node).transition(state, response)
        rescue ArgumentError, InvalidResponse => e
          state.clone.tap do |new_state|
            new_state.error = e.message
            new_state.freeze
          end
        end
      end
    end

    def path(responses)
      process(responses).path
    end

    def normalize_responses(responses)
      process(responses).responses
    end    
    
    def is_group?
      true
    end

    private
      def add_node(node)         
        Rails.logger.info(@nodes.inspect)
        Rails.logger.info("#{self.class.to_s}")
        Rails.logger.info("Adding #{node}")
        raise "Node #{node.name} already defined" if node_exists?(node)
        @nodes << node
      end
    
  end
end