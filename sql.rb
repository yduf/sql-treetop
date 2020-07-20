require 'treetop'

# extend all node with method and default behavior
class Treetop::Runtime::SyntaxNode
    def ast()
        if elements
            elements.map { |e| e.ast() }
        else
            nil
        end
    end

    def as_sql
        if elements
            elements.map { |e| e.as_sql }.join
        else
            text_value
        end
    end
end


module SQL
    module Select
    end

    class TableName < Treetop::Runtime::SyntaxNode
        def ast()
            [ "#{self.class}:#{text_value.strip}" ]
        end

        def as_sql()
            "my.table "
        end
    end

    class ColumnReference < Treetop::Runtime::SyntaxNode
        def ast()
            [ "#{self.class}:#{text_value.strip}" ]
        end

        def as_sql()
            "my.column "
        end
    end

    class Identifier < Treetop::Runtime::SyntaxNode
        def ast()
            [ "#{self.class}:#{text_value.strip}" ]
        end
    end
end

# Find out what our base path is
require 'delegate'

class Parser

    # Allows to inject parser object as a parameter that can be used inside parsing
    # usefull to share global information at the parser level
    # https://github.com/cjheath/activefacts-cql/blob/master/lib/activefacts/cql/parser.rb#L203-L249
    class InputProxy < SimpleDelegator
        attr_reader :parser
        
        def initialize( input, parser)
            super( input)
            @parser = parser
        end
    end

    @@base_path = File.expand_path(File.dirname(__FILE__))

    Treetop.load( File.join(@@base_path, 'sql.treetop'))
    @@parser = SQLParser.new

    def self.parse(input, options = {})
        parser = @@parser
        input = InputProxy.new( input, self)
        match = parser.parse(input, options)
        if match.nil?
            parser.failure_reason =~ /^(Expected .+) after/m
            puts "ERROR: #{$1.gsub("\n", '$NEWLINE')}:"
            puts input.lines.to_a[ parser.failure_line - 1]
            puts "#{'~' * ( parser.failure_column - 1)}^"        
            nil
        else
            match
        end
    end
end

