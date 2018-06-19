--all comment must be written in latin charset because of this file charset is set to ANSI
--but all other files in project are set to UTF-8

--this robot updates quotes in table named 'positions' in SQLite database
--the file lsqlite3.dll must be placed to QUIK's directory
--version sqlite3.dll must be x86

local sqlite3 = require("lsqlite3")
db = sqlite3.open("c:\\WORK\\fifo\\DealsViewer\\DealsViewer.db")

-- Constants --

-- Global variables --


------------------------
is_run = true

function OnStop(s)
  is_run = false
end



function main()

	i=1 --for debug
	
	while is_run do
	
		
  
		--last = 1324.548
		--last = 65000
		--sec_code = 'SiZ6'
		--class_code = 'SPBFUT'
		--message(tostring(sec_code))
		--message(tostring(db:isopen()))

		
		--select all unique ticker from table "positions" and update their quotes
		for row in db:rows('SELECT DISTINCT ticker, class FROM positions') do 
			
		
			--getting quotes
			--parameter names are described in info.chm, you should execute search by word "GET_PARAM_EX" and choose chapter "Znacheniya parametrov funkciy"
			sec_code = row[1]
			class_code = row[2]
			
			--message(tostring(i))
			
			--message(tostring(sec_code))
			
			--message(tostring(class_code))
			
			tabQuotes = getParamEx (class_code, sec_code, 'bid')
			bid = tabQuotes.param_value
			--bid = i+1
			
			tabQuotes = getParamEx (class_code, sec_code, 'ask')
			ask = tabQuotes.param_value
			--ask = i+2
			
			tabQuotes = getParamEx (class_code, sec_code, 'last')
			last = tabQuotes.param_value
			--last = i+3

			
			
			db:exec("UPDATE positions SET "..
			"bid = '"..tostring(bid).."',"..
			"ask = '"..tostring(ask).."',"..
			"last = '"..tostring(last).."'"..
			" WHERE ticker = '"..sec_code.."' AND class = '"..class_code.."'")
			
			i=i+1
		
		end
		
  
    sleep(1000)
  end
    
end



---- Event handlers ----

function OnInit(s)
  
end

function OnQuote(class_code, sec_code)
	--update quotes in  "positions" table
end

function OnTransReply(repl)

	
end

function OnTrade(trade)

	--add deal into "deals" table
--test	
end



