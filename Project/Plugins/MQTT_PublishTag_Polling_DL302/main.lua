mqtt = MQTTAPI()
daq = DAQAPI()

-- Used to check if the value has changed
co2 = nil
rh = nil
tempc = nil
tempf = nil

function on_process()
	local value = daq:Read("dl302_1", "CO2")

	if (value ~= co2) then
		mqtt:Publish("mqtt2", "CO2.Notify", value, 2, false)
		co2 = value;
	end

	value = daq:Read("dl302_1", "RH")
	if (value ~= rh) then
		mqtt:Publish("mqtt2", "RH.Notify", value, 2, false)
		rh = value;
	end

	value = daq:Read("dl302_1", "TEMP_C")
	if (value ~= tempc) then
		mqtt:Publish("mqtt2", "TEMP_C.Notify", value, 2, false)
		tempc = value;
	end
	
	value = daq:Read("dl302_1", "TEMP_F")
	if (value ~= tempf) then
		mqtt:Publish("mqtt2", "TEMP_F.Notify", value, 2, false)
		tempf = value;
	end	

end

print("MQTT Publish Tag, Polling Mode")



