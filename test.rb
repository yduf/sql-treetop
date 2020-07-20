require_relative 'sql'

load('sql.rb')
m = Parser.parse(' select  /*+ first_rows(1) */ a.A,b,d as cd from d.d where 1=1')
    .ast.flatten.compact

