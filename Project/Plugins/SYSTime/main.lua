mqtt = MQTTAPI()
daq = DAQAPI()
JSON = require("modules/JSON")

local ems_prompt = "/BOFI/gaius/sp4k/1/"

function wait(seconds)
	local start = os.time()
	repeat until os.time() > start + seconds
end

function on_report(context)
	-- local deviceId = context.information.DeviceID
	-- local connected = context.information.Connected
	local sys_time = os.date('%Y-%m-%d %H:%M:%S')
	
	mqtt:Publish("mqtt2", ems_prompt .. "sysTime", sys_time, 1, true)
	wait(2)
end

daq:OnReport(on_report)
print("MQTT Publish Tag, Event Mode")
