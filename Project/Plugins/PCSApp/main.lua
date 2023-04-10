mqtt = MQTTAPI()
daq = DAQAPI()
JSON = require("modules/JSON")

-- Used to check if the value has changed
error0 = nil
error1 = nil
wMode = nil
bV = nil
bT = nil
acInAcP = nil
acOutV = nil
acOutAcP = nil
acOutF = nil
acOutC = nil
bCap = nil
sInP1 = nil
bC = nil
sInV1 = nil
maxT = nil
acInToAcP = nil
acInC = nil
sInC1 = nil
acOutAppPP = nil
acInV = nil
acInF = nil
acOutPP = nil
innT = nil
status0 = nil
status1 = nil
acOutToP = nil
bP = nil
totGenE = nil
genEnH = nil
genEnD = nil
genEnM = nil
genEnY = nil
saveT = nil
dateHourE = nil
dateDayE = nil
dateMonE = nil
dateYearE = nil
con1 = nil
con2 = nil
con3 = nil
con4 = nil


local ems_prompt = "/BOFI/gaius/sp4k/1/"

function CreateDatabase(influx)
	local resp = influx:CreateDB("ems_db")
	if (resp ~= nil and resp["error"] ~= nil) then
	  print("Error:" .. resp.error)
	else
	  print("create database 'ems_db'")
	end
end

function on_report(context)
	-- local influx = InfluxDB("192.168.1.11", 8086, "admin", "admin", "ems_db")
	local deviceId = context.information.DeviceID
	local connected = context.information.Connected
	-- local value = daq:Read("A_INV_1", "PV1_V_I")
	local value = nil
	-- local retTable = {}

	-- if (connected == nil) or (not connected) then
	-- 	retTable["Error_Code"] = nil;
	-- 	retTable["INV_State"] = nil;
	-- 	retTable["INV_State2"] = nil;
	-- 	retTable["AB_V_O"] = nil;
	-- 	retTable["BC_V_O"] = nil;
	-- 	retTable["CA_V_O"] = nil;
	-- 	retTable["A_I_O"] = nil;
	-- 	retTable["B_I_O"] = nil;
	-- 	retTable["C_I_O"] = nil;
	-- 	retTable["OnG_Freq_O"] = nil;
	-- 	retTable["TP_O"] = nil;
	-- 	retTable["V_D"] = nil;
	-- 	retTable["I_D"] = nil;
	-- 	retTable["P_D"] = nil;
	-- 	retTable["Discharge_Today"] = nil;
	-- 	retTable["Charge_Today"] = nil;
	-- 	retTable["PCS_P_Set"] = nil;
	-- 	retTable["PCS_C_Mode_Set"] = nil;
	-- 	retTable["Shutdown"] = nil;
	-- 	return
	-- end

	if ((deviceId == "gaiusPCS1") and (connected == true)) then
		
		value = context.parameters["error0"].value
		mqtt:Publish("mqtt2", ems_prompt .. "error0", value, 1, false)
		-- if (value ~= error0) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "error0", value, 1, false)
		-- 	error0 = value;
		-- end

		value = context.parameters["error1"].value
		mqtt:Publish("mqtt2", ems_prompt .. "error1", value, 1, false)
		-- if (value ~= error1) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "error1", value, 1, false)
		-- 	error1 = value;
		-- end

		value = context.parameters["wMode"].value
		mqtt:Publish("mqtt2", ems_prompt .. "wMode", value, 1, false)
		-- if (value ~= wMode) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "wMode", value, 1, false)
		-- 	wMode = value;
		-- end

		value = context.parameters["bV"].value * 0.1
		mqtt:Publish("mqtt2", ems_prompt .. "bV", value, 1, false)
		-- if (value ~= bV) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "bV", value, 1, false)
		-- 	bV = value;
		-- end

		value = context.parameters["bT"].value
		mqtt:Publish("mqtt2", ems_prompt .. "bT", value, 1, false)
		-- if (value ~= bT) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "bT", value, 1, false)
		-- 	bT = value;
		-- end

		value = context.parameters["acInAcP"].value
		mqtt:Publish("mqtt2", ems_prompt .. "acInAcP", value, 1, false)
		-- if (value ~= acInAcP) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acInAcP", value, 1, false)
		-- 	acInAcP = value;
		-- end

		value = context.parameters["acOutV"].value * 0.1
		mqtt:Publish("mqtt2", ems_prompt .. "acOutV", value, 1, false)
		-- if (value ~= acOutV) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acOutV", value, 1, false)
		-- 	acOutV = value;
		-- end

		value = context.parameters["acOutAcP"].value
		mqtt:Publish("mqtt2", ems_prompt .. "acOutAcP", value, 1, false)
		-- if (value ~= acOutAcP) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acOutAcP", value, 1, false)
		-- 	acOutAcP = value;
		-- end

		value = context.parameters["acOutF"].value * 0.01
		mqtt:Publish("mqtt2", ems_prompt .. "acOutF", value, 1, false)
		-- if (value ~= acOutF) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acOutF", value, 1, false)
		-- 	acOutF = value;
		-- end

		value = context.parameters["acOutC"].value * 0.1
		mqtt:Publish("mqtt2", ems_prompt .. "acOutC", value, 1, false)
		-- if (value ~= acOutC) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acOutC", value, 1, false)
		-- 	acOutC = value;
		-- end

		value = context.parameters["bCap"].value
		mqtt:Publish("mqtt2", ems_prompt .. "bCap", value, 1, false)
		-- if (value ~= bCap) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "bCap", value, 1, false)
		-- 	bCap = value;
		-- end

		value = context.parameters["sInP1"].value
		mqtt:Publish("mqtt2", ems_prompt .. "sInP1", value, 1, false)
		-- if (value ~= sInP1) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "sInP1", value, 1, false)
		-- 	sInP1 = value;
		-- end

		value = context.parameters["bC"].value * 0.1
		mqtt:Publish("mqtt2", ems_prompt .. "bC", value, 1, false)
		-- if (value ~= bC) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "bC", value, 1, false)
		-- 	bC = value;
		-- end

		value = context.parameters["sInV1"].value * 0.1
		mqtt:Publish("mqtt2", ems_prompt .. "sInV1", value, 1, false)
		-- if (value ~= sInV1) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "sInV1", value, 1, false)
		-- 	sInV1 = value;
		-- end

		value = context.parameters["maxT"].value
		mqtt:Publish("mqtt2", ems_prompt .. "maxT", value, 1, false)
		-- if (value ~= maxT) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "maxT", value, 1, false)
		-- 	maxT = value;
		-- end

		value = context.parameters["acInToAcP"].value
		mqtt:Publish("mqtt2", ems_prompt .. "acInToAcP", value, 1, false)
		-- if (value ~= acInToAcP) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acInToAcP", value, 1, false)
		-- 	acInToAcP = value;
		-- end

		value = context.parameters["acInC"].value * 0.1
		mqtt:Publish("mqtt2", ems_prompt .. "acInC", value, 1, false)
		-- if (value ~= acInC) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acInC", value, 1, false)
		-- 	acInC = value;
		-- end

		value = context.parameters["sInC1"].value * 0.1
		mqtt:Publish("mqtt2", ems_prompt .. "sInC1", value, 1, false)
		-- if (value ~= sInC1) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "sInC1", value, 1, false)
		-- 	sInC1 = value;
		-- end

		value = context.parameters["acOutAppP"].value
		mqtt:Publish("mqtt2", ems_prompt .. "acOutAppP", value, 1, false)
		-- if (value ~= acOutAppPP) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acOutAppPP", value, 1, false)
		-- 	acOutAppPP = value;
		-- end

		value = context.parameters["acInV"].value * 0.1
		mqtt:Publish("mqtt2", ems_prompt .. "acInV", value, 1, false)
		-- if (value ~= acInV) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acInV", value, 1, false)
		-- 	acInV = value;
		-- end

		value = context.parameters["acInF"].value * 0.01
		mqtt:Publish("mqtt2", ems_prompt .. "acInF", value, 1, false)
		-- if (value ~= acInF) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acInF", value, 1, false)
		-- 	acInF = value;
		-- end

		value = context.parameters["acOutPP"].value
		mqtt:Publish("mqtt2", ems_prompt .. "acOutPP", value, 1, false)
		-- if (value ~= acOutPP) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acOutPP", value, 1, false)
		-- 	acOutPP = value;
		-- end

		value = context.parameters["innT"].value
		mqtt:Publish("mqtt2", ems_prompt .. "innT", value, 1, false)
		-- if (value ~= innT) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "innT", value, 1, false)
		-- 	innT = value;
		-- end

		value = context.parameters["status0"].value
		mqtt:Publish("mqtt2", ems_prompt .. "status0", value, 1, false)
		-- if (value ~= status) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "status", value, 1, false)
		-- 	status = value;
		-- end

		value = context.parameters["status1"].value
		mqtt:Publish("mqtt2", ems_prompt .. "status1", value, 1, false)
		-- if (value ~= status) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "status", value, 1, false)
		-- 	status = value;
		-- end

		value = context.parameters["acOutToP"].value
		mqtt:Publish("mqtt2", ems_prompt .. "acOutToP", value, 1, false)
		-- if (value ~= acOutToP) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "acOutToP", value, 1, false)
		-- 	acOutToP = value;
		-- end

		value = context.parameters["bP"].value
		mqtt:Publish("mqtt2", ems_prompt .. "bP", value, 1, false)
		-- if (value ~= bP) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "bP", value, 1, false)
		-- 	bP = value;
		-- end

		value = context.parameters["totGenE"].value
		mqtt:Publish("mqtt2", ems_prompt .. "totGenE", value, 1, false)
		-- if (value ~= totGenE) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "totGenE", value, 1, false)
		-- 	totGenE = value;
		-- end

		value = context.parameters["genEnH"].value
		mqtt:Publish("mqtt2", ems_prompt .. "genEnH", value, 1, false)
		-- if (value ~= genEnH) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "genEnH", value, 1, false)
		-- 	genEnH= value;
		-- end

		value = context.parameters["genEnD"].value
		mqtt:Publish("mqtt2", ems_prompt .. "genEnD", value, 1, false)
		-- if (value ~= genEnD) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "genEnD", value, 1, false)
		-- 	genEnD= value;
		-- end

		value = context.parameters["genEnM"].value
		mqtt:Publish("mqtt2", ems_prompt .. "genEnM", value, 1, false)
		-- if (value ~= genEnM) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "genEnM", value, 1, false)
		-- 	genEnM= value;
		-- end

		value = context.parameters["genEnY"].value
		mqtt:Publish("mqtt2", ems_prompt .. "genEnY", value, 1, false)
		-- if (value ~= genEnY) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "genEnY", value, 1, false)
		-- 	genEnY= value;
		-- end

		-- value = context.parameters["saveT"].value
		-- mqtt:Publish("mqtt2", ems_prompt .. "saveT", value, 1, false)
		-- if (value ~= saveT) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "saveT", value, 1, false)
		-- 	saveT= value;
		-- end

		-- value = context.parameters["dateHourE"].value
		-- mqtt:Publish("mqtt2", ems_prompt .. "dateHourE", value, 1, false)
		-- if (value ~= dateHourE) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "dateHourE", value, 1, false)
		-- 	dateHourE= value;
		-- end

		-- value = context.parameters["dateDayE"].value
		-- mqtt:Publish("mqtt2", ems_prompt .. "dateDayE", value, 1, false)
		-- if (value ~= dateDayE) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "dateDayE", value, 1, false)
		-- 	dateDayE= value;
		-- end

		-- value = context.parameters["dateMonE"].value
		-- mqtt:Publish("mqtt2", ems_prompt .. "dateMonE", value, 1, false)
		-- if (value ~= dateMonE) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "dateMonE", value, 1, false)
		-- 	dateMonE= value;
		-- end

		-- value = context.parameters["dateYearE"].value
		-- mqtt:Publish("mqtt2", ems_prompt .. "dateYearE", value, 1, false)
		-- if (value ~= dateYearE) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "dateYearE", value, 1, false)
		-- 	dateYearE= value;
		-- end

		value = context.parameters["con1"].value
		mqtt:Publish("mqtt2", ems_prompt .. "con1", value, 1, false)
		-- if (value ~= con1) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "con1", value, 1, false)
		-- 	con1= value;
		-- end

		value = context.parameters["con2"].value
		mqtt:Publish("mqtt2", ems_prompt .. "con2", value, 1, false)
		-- if (value ~= con2) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "con2", value, 1, false)
		-- 	con2= value;
		-- end

		value = context.parameters["con3"].value
		mqtt:Publish("mqtt2", ems_prompt .. "con3", value, 1, false)
		-- if (value ~= con3) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "con3", value, 1, false)
		-- 	con3= value;
		-- end

		value = context.parameters["con4"].value
		mqtt:Publish("mqtt2", ems_prompt .. "con4", value, 1, false)
		-- if (value ~= con4) then
		-- 	mqtt:Publish("mqtt2", ems_prompt .. "con4", value, 1, false)
		-- 	con4= value;
		-- end

		-- retTable["Error_Code"] = Error_Code;
		-- retTable["INV_State"] = INV_State;
		-- retTable["INV_State2"] = INV_State2;
		-- retTable["AB_V_O"] = AB_V_O;
		-- retTable["BC_V_O"] = BC_V_O;
		-- retTable["CA_V_O"] = CA_V_O;
		-- retTable["A_I_O"] = A_I_O;
		-- retTable["B_I_O"] = B_I_O;
		-- retTable["C_I_O"] = C_I_O;
		-- retTable["OnG_Freq_O"] = OnG_Freq_O;
		-- retTable["TP_O"] = TP_O;
		-- retTable["V_D"] = V_D;
		-- retTable["I_D"] = I_D;
		-- retTable["P_D"] = P_D;
		-- retTable["Discharge_Today"] = Discharge_Today;
		-- retTable["Charge_Today"] = Charge_Today;
		-- retTable["PCS_P_Set"] = PCS_P_Set;
		-- retTable["PCS_C_Mode_Set"] = PCS_C_Mode_Set;
		-- retTable["Shutdown"] = Shutdown;

		-- local jsonStr = JSON:encode(retTable);
		-- local cmd = "pcss,pcs=1" 
		-- 			.. " Error_Code=" .. tostring(retTable["Error_Code"])
		-- 			.. ",INV_State=" .. tostring(retTable["INV_State"])
		-- 			.. ",INV_State2=" .. tostring(retTable["INV_State2"])
		-- 			.. ",AB_V_O=" .. tostring(retTable["AB_V_O"])
		-- 			.. ",BC_V_O=" .. tostring(retTable["BC_V_O"])
		-- 			.. ",CA_V_O=" .. tostring(retTable["CA_V_O"])
		-- 			.. ",A_I_O=" .. tostring(retTable["A_I_O"])
		-- 			.. ",B_I_O=" .. tostring(retTable["B_I_O"])
		-- 			.. ",C_I_O=" .. tostring(retTable["C_I_O"])
		-- 			.. ",OnG_Freq_O=" .. tostring(retTable["OnG_Freq_O"])
		-- 			.. ",TP_O=" .. tostring(retTable["TP_O"])
		-- 			.. ",V_D=" .. tostring(retTable["V_D"])
		-- 			.. ",I_D=" .. tostring(retTable["I_D"])
		-- 			.. ",P_D=" .. tostring(retTable["P_D"])
		-- 			.. ",Discharge_Today=" .. tostring(retTable["Discharge_Today"])
		-- 			.. ",Charge_Today=" .. tostring(retTable["Charge_Today"])
		-- 			-- .. ",PCS_P_Set=" .. tostring(retTable["PCS_P_Set"])
		-- 			-- .. ",PCS_C_Mode_Set=" .. tostring(retTable["PCS_C_Mode_Set"])
		-- 			-- .. ",Shutdown=" .. tostring(retTable["Shutdown"])
					
		-- local resp = influx:Write(cmd)
	end
end

-- InfluxDB(host, port, user, password, db_name)
-- CreateDatabase(InfluxDB("192.168.1.11", 8086, "admin", "admin", "ems_db"))
daq:OnReport(on_report)
print("MQTT Publish Tag, Event Mode")
