Initial play with treetop to try parsing sql.


# Cutting parsing tree

Don't know if it a good idea but using 

module SQL
    # custom Node for cutting parsing tree
    class CutTree < Treetop::Runtime::SyntaxNode
        def initialize( input, interval, elements = nil)
            super( input, interval, nil)
        end
    end
    
    # 
    class KW < CutTree
    end

end

allows to cut significantly unusefull part of the tree build by treetop:
exemple: 
    rule SELECT
        'select'i kw                       <KW>
    end

[15] pry(main)> m = Parser.parse("select col as a  /* truc */ from T")

before
    SyntaxNode+SELECT0 offset=0, "select " (kw):
      SyntaxNode offset=0, "select"
      SyntaxNode+Kw0 offset=6, " " (s):
        SyntaxNode offset=6, ""
        SyntaxNode offset=6, " ":
          SyntaxNode offset=6, " ":
            SyntaxNode offset=6, " "
    SyntaxNode offset=7, ""

after
    KW+SELECT0 offset=0, "select " (kw)
    SyntaxNode offset=7, ""
