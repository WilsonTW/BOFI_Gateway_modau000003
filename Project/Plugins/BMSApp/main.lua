local bms = require("modules/AnfuBMS")

rs232 = require("luars232")
inspect = require("modules/inspect")

-- Linux
port_name = "/dev/serial1"

-- (Open)BSD
-- port_name = "/dev/cua00"

-- Windows
-- port_name = "COM1"

local out = io.stderr
mqtt = MQTTAPI()

function publish_report(packno, report, warn)
	local rootPath = "/BOFI/gaius/zdaf/" .. tostring(packno)
	local clientID = "aws-server"
	local totalWarnCount = 0
	
	--print(inspect(report))
	--print(inspect(warn))
	
	---------------------------------------------------------------------------------------------------------------------------
	-- Publish Battery Data
	mqtt:Publish(clientID, rootPath .. "/vM", tostring(report.BatteryCellNumber), 2, false)
	
	for i = 1, #report.BatteryCellVoltages do 
		if (report.BatteryCellVoltages[i] ~= nil) then
			mqtt:Publish(clientID, rootPath .. "/v" .. tostring(i), tostring(report.BatteryCellVoltages[i]), 2, false)
		end
	end
	
	mqtt:Publish(clientID, rootPath .. "/tN", tostring(report.TemperatureNumber), 2, false)
	for i = 1, #report.Temperatures do 
		if (report.Temperatures[i] ~= nil) then
			mqtt:Publish(clientID, rootPath .. "/t" .. tostring(i), tostring(report.Temperatures[i]), 2, false)
		end
	end	
	
	mqtt:Publish(clientID, rootPath .. "/tA", tostring(report.PackCurrent), 2, false)
	mqtt:Publish(clientID, rootPath .. "/tV", tostring(report.PackVoltage), 2, false)
	mqtt:Publish(clientID, rootPath .. "/sAh", tostring(report.RemainingCapacity), 2, false)
	mqtt:Publish(clientID, rootPath .. "/tAh", tostring(report.FullCapacity), 2, false)
	mqtt:Publish(clientID, rootPath .. "/cycle", tostring(report.CycleCount), 2, false)
	mqtt:Publish(clientID, rootPath .. "/soc", tostring(report.SOC), 2, false)
	mqtt:Publish(clientID, rootPath .. "/soh", tostring(report.SOH), 2, false)
	mqtt:Publish(clientID, rootPath .. "/equal", tostring(report.Balance_01_16), 2, false)
	mqtt:Publish(clientID, rootPath .. "/humidity", tostring(report.Humidity), 2, false)
	
	---------------------------------------------------------------------------------------------------------------------------
	-- Publish Warn Status
	mqtt:Publish(clientID, rootPath .. "/vMWarn", tostring(warn.BatteryCellNumber), 2, false)
	for i = 1, #warn.BatteryCellVoltages do 
		if (warn.BatteryCellVoltages[i] ~= nil) then 
			if (warn.BatteryCellVoltages[i] ~= 0) then 
				totalWarnCount = totalWarnCount + 1 
			end
			mqtt:Publish(clientID, rootPath .. "/v" .. tostring(i) .. "Warn", string.format("%02XH", warn.BatteryCellVoltages[i]), 2, false)
		end
	end	
	
	mqtt:Publish(clientID, rootPath .. "/tNWarn", tostring(warn.TemperatureNumber), 2, false)
	for i = 1, #warn.Temperatures do 
		if (warn.Temperatures[i] ~= nil) then
			if (warn.Temperatures[i] ~= 0) then 
				totalWarnCount = totalWarnCount + 1 
			end
			mqtt:Publish(clientID, rootPath .. "/t" .. tostring(i) .. "Warn", string.format("%02XH", warn.Temperatures[i]), 2, false)
		end
	end	
	
	if (warn.PackCurrent ~= 0) then 
		totalWarnCount = totalWarnCount + 1 
	end	
	mqtt:Publish(clientID, rootPath .. "/tAWarn", string.format("%02XH", warn.PackCurrent), 2, false)

	if (warn.PackVoltage ~= 0) then 
		totalWarnCount = totalWarnCount + 1 
	end	
	mqtt:Publish(clientID, rootPath .. "/tVWarn", string.format("%02XH", warn.PackVoltage), 2, false)

	mqtt:Publish(clientID, rootPath .. "/totWarn", tostring(totalWarnCount), 2, false)	
end

function on_process()
	local reports = {}
	local warns = {}

	-- open port
	local e, p = rs232.open(port_name)

	if e ~= rs232.RS232_ERR_NOERROR then
		-- handle error
		out:write(string.format("can't open serial port '%s', error: '%s'\n",
				port_name, rs232.error_tostring(e)))
		return
	end

	-- set port settings
	assert(p:set_baud_rate(rs232.RS232_BAUD_9600) == rs232.RS232_ERR_NOERROR)
	assert(p:set_data_bits(rs232.RS232_DATA_8) == rs232.RS232_ERR_NOERROR)
	assert(p:set_parity(rs232.RS232_PARITY_NONE) == rs232.RS232_ERR_NOERROR)
	assert(p:set_stop_bits(rs232.RS232_STOP_1) == rs232.RS232_ERR_NOERROR)
	assert(p:set_flow_control(rs232.RS232_FLOW_OFF)  == rs232.RS232_ERR_NOERROR)

	print("Serial Port:" .. tostring(p))

	bms:BindPort(p)

	for i = 1, 1 do
		print("--------------------------------------------------------------------------")
		print("pack" .. tostring(i))

		e, reports[i] = bms:ReadReport(i)
		if (e == 0) then
			e, warns[i] = bms:ReadAlarmStatus(i)
			if (e == 0) then
				publish_report(i, reports[i], warns[i])
			else
				print("Read Warn Status Error," .. tostring(e))
			end
		else
			print("Read Report Error," .. tostring(e))
		end
	end

	p:close()
end


