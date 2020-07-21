require 'json'
require_relative 'sql'

load('sql.rb')  # load grammar

test_sql=<<_
select * from b
select 1 b from  dual 
select  /*+ first_rows(1) */ a.A,b,d as cd from d.d where 1=1
select * from UND_POOL_ASSET_RANK where FLAG_FULLY_COVERED is null or FLAG_FULLY_COVERED in ('T', 'F')
select * from SWAP where cash_margin is null or cash_margin = 0 or margin_types <> 'O'
select * from SWAP where pay_discount_curve_name is null or pay_currency = pack_currency.get_curve_currency(pay_discount_curve_name)
select * from SWAP where exists(select 1 from dual)
select * from SWAP where :new.contract_type in ('A','b')
select * from SWAP where :new.contract_type in (select ct_code_user from contract_types where contract_category=:table_name)
_


test_sql.each_line do |line|
    m = Parser.parse(line)
    if m.nil?
    else
        puts "OK => #{line}"
        # puts m.ast.flatten.compact.to_s
        # puts m.as_sql
    end
end

# exit(0)

input = JSON.parse( File.read('C:\Work\maers-brt-bc-alm-configfiles\rfo\constraint\constraints.json'))

total = 0
xcount = 0

input.each { |k,v| 
    puts "table #{k}"
    count = 0
    v.each{ |rule|
        count += 1
        total += 1
        source = rule["source"]
        next if source.nil?

        begin
            #ast = Parser.parse("select * from #{k} where #{source}")
            ast = Parser.parse("select (#{source}) as valid from #{k}")
            if ast.nil?
                puts "ERROR on rule #{count}"
                xcount += 1
            else
                puts "OK => #{source}"
            end
        rescue => x
            xcount += 1
            puts x.to_s
            puts rule.to_s
            # raise x
        end
    }
}

puts "Rules #{total - xcount}/#{total}"
