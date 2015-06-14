local getopt = require('getopt')
local utils = require('utils')

example = "script calculates many different checksums (CRC) over the provided hex input"
author = "Iceman"
desc =
[[
This script calculates many checksums (CRC) over the provided hex input. 

Arguments:
	-b 				data in hex
	-w				bitwidth of the CRC family of algorithm. <optional> defaults to all known CRC presets.
Examples : 
	script run e -b 010203040506070809
	script run e -b 010203040506070809 -w 16
]]

--- 
-- A debug printout-function
function dbg(args)
	if DEBUG then
		print("###", args)
	end
end 
--- 
-- This is only meant to be used when errors occur
function oops(err)
	print("ERROR: ",err)
	return nil,err
end
--- 
-- Usage help
function help()
	print(desc)
	print("Example usage")
	print(example)
end
--- 
-- The main entry point
function main(args)

	local data
	local width = 0

	-- Read the parameters
	for o, a in getopt.getopt(args, 'hb:w:') do
		if o == "h" then return help() end
		if o == "b" then data = a end
		if o == "w" then width = a end
	end

	data = data or '01020304'
	
	print( string.rep('-',60) )
	print('Bit width of CRC | '..width)
	print('Bytes            | '..data)
	print('')
	print( ('%-20s| %-16s| %s'):format('Model','CRC', 'CRC reverse'))
	print( string.rep('-',60) )
	local lists = core.reveng_models(width)
	for _,i in pairs(lists) do
		local one = core.reveng_runmodel(i, data, false, '0')
		local two = core.reveng_runmodel(i, data, true, '0')
		print( ('%-20s| %-16s| %s'):format(i, one:upper(), two:upper()) )
	end
end

main(args)