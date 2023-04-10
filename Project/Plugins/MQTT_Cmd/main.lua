mqtt = MQTTAPI()

local client_id = "bofi" .. "modau000003"
--local f = assert(io.popen("cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2"))
--local handle = assert(f:read('*a'))
--f:close()
--client_id2 = string.format("%s",handle)
local client_id2 = "bofi" .. "modau000003"
local me = "pi/ModauMe"

function on_message(context)
	local topic = context.topic
	local value = tonumber(context.payload)
	local cmd000 = "sudo reboot"
	local cmd001 = {"sudo /etc/init.d/cpolar start-all &", "sudo /etc/init.d/cpolar.stop"}
--	local cmd001_0 = "ps -aux | grep cpolar | grep -v grep | awk '{print $2}' | xargs kill -9"
--	local cmd001_0 = "sudo /etc/init.d/cpolar.stop"
--	local client_id = "701fe498312248409e796b294dd0cc89123"	
 
	print("topic=" .. context.topic)
	print("value=" .. context.payload)

  	if (value == nil) then
   		--value is not a number
    	return;
  	end
  
	if (topic == client_id2 .. "CMD001") then
    	if (value ~= 0) then
			print("value ~= 0")
			os.execute(cmd001[1])
		else
			print("value = 0")
			os.execute(cmd001[2])
		end	
	elseif (topic == client_id2 .. "CMD000") then
		if (value == 1) then
			os.execute(cmd000)
		end
	elseif (topic == me) then
		mqtt:Publish("mqtt1", "modau", client_id2, 2, true)
		mqtt:Publish("mqtt2", "modau", client_id2, 2, true)
--		os.execute(cmd001[1])
	end
end

print("MQTT Execute CMD")

--Register Receive Message event
mqtt:OnMessage(on_message);

--Subscribe topic
mqtt:Subscribe("mqtt1", client_id2 .. "CMD001", 2);
mqtt:Subscribe("mqtt1", client_id2 .. "CMD000", 2);
mqtt:Subscribe("mqtt1", "Error", 2);
mqtt:Subscribe("mqtt1", me, 2);

mqtt:Subscribe("mqtt2", client_id2 .. "CMD001", 2);
mqtt:Subscribe("mqtt2", client_id2 .. "CMD000", 2);
mqtt:Subscribe("mqtt2", "Error", 2);
mqtt:Subscribe("mqtt2", me, 2);

--print("Publish")
--mqtt:Publish("mqtt1", "modau", "hello", 2, false);



