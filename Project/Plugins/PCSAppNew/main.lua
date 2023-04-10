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
greenPer = nil
dayCount = 0
sliceGreenE = 0
sliceGreyE = 0
calAcInP = nil
endTime = nil
acOutAcTmpP = 0
sumGreenE = 0
sumGreyE = 0
lastGreenE = 0
lastGreyE = 0
acOutAcRetP = 0

local ems_prompt = "/BOFI/gaius/sp4k/1/"
local startTime = os.time()

local date_list = {}
local today = os.date("*t")
date_list.day = today.day
date_list.month = today.month
date_list.year = today.year

local function is_today()
	if not date_list.day then
		return false
	end
	local timestamp = os.time()
	local sToday = os.time({day = date_list.day, month = date_list.month, year = date_list.year, hour = 0, min = 0, sec = 0 })
	if timestamp > sToday and timestamp <= sToday + 24 * 60 * 60 then
		return true
	else
		return false
	end
end

function on_report(context)
	local deviceId = context.information.DeviceID
	local connected = context.information.Connected
	local value = nil
	local retTable = {}
	local endTime = nil

	-- if (connected == nil) or (not connected) then
	-- 	retTable["greenPer"] = nil;
	-- 	retTable["dayCount"] = nil;
	-- 	retTable["lastGreenE"] = nil;
	-- 	retTable["lastGreyE"] = nil;
	-- 	retTable["sumGreenE"] = nil;
	-- 	retTable["sumGreyE"] = nil;
	-- 	retTable["acOutAcP"] = nil;
	-- 	retTable["acOutAcTmpP"] = nil;
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

		-- value = context.parameters["acInAcP"].value
		-- mqtt:Publish("mqtt2", ems_prompt .. "acInAcP", value, 1, false)
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

		-- value = context.parameters["acInToAcP"].value
		-- mqtt:Publish("mqtt2", ems_prompt .. "acInToAcP", value, 1, false)
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

		value = context.parameters["sInC1"].value * 0.01
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
		
		calAcInP = context.parameters["acOutAcP"].value - context.parameters["sInP1"].value - (-1 * context.parameters["bV"].value * 0.1 * context.parameters["bC"].value * 0.1 )
		if (calAcInP < 0) and (context.parameters["sInP1"].value == 0) then
			calAcInP = 0.0001
		end
		if (calAcInP < 0) and (context.parameters["sInP1"].value > 0) then
			calAcInP = 0
		end
		mqtt:Publish("mqtt2", ems_prompt .. "acInAcP", calAcInP, 1, false)
		mqtt:Publish("mqtt2", ems_prompt .. "acInToAcP", calAcInP, 1, false)
		greenPer = context.parameters["sInP1"].value / (context.parameters["sInP1"].value + calAcInP)

		mqtt:Publish("mqtt2", ems_prompt .. "greenPer", greenPer, 1, false)
		
		-- Calculate dayCount, lastGreenE, lastGreyE, sumGreenE, sumGreyE
		endTime = os.time()
		mqtt:Publish("mqtt2", ems_prompt .. "eTime", (endTime - startTime), 1, false)
		-- sliceGreenE = greenPer * (retTable["acOutAcTmpP"] + context.parameters["acOutAcP"].value) * (endTime - startTime) / 2 / 3600000
		sliceGreenE = greenPer * (acOutAcTmpP + context.parameters["acOutAcP"].value) * (endTime - startTime) / 2 / 3600000
		mqtt:Publish("mqtt2", ems_prompt .. "sliceGreenE", sliceGreenE, 1, true)
		sumGreenE = sumGreenE + sliceGreenE
		sliceGreyE = (1 - greenPer) * (acOutAcTmpP + context.parameters["acOutAcP"].value) * (endTime - startTime) / 2 / 3600000 
		mqtt:Publish("mqtt2", ems_prompt .. "sliceGreyE", sliceGreyE, 1, true)
		sumGreyE = sumGreyE + sliceGreyE
		if (context.parameters["acOutAcP"].value >= 100) then
			if (acOutAcRetP < 100) then
				dayCount = dayCount + 1
				acOutAcRetP = context.parameters["acOutAcP"].value
				-- mqtt:Publish("mqtt2", ems_prompt .. "dayCount", dayCount, 1, true)
				-- retTable["acOutAcP"] = context.parameters["acOutAcP"].value
				lastGreenE = 0
				lastGreyE = 0
			end
			mqtt:Publish("mqtt2", ems_prompt .. "dayCount", dayCount, 1, true)
			lastGreenE = lastGreenE + sliceGreenE
			lastGreyE = lastGreyE + sliceGreyE
			mqtt:Publish("mqtt2", ems_prompt .. "lastGreenE", lastGreenE, 1, true)
			mqtt:Publish("mqtt2", ems_prompt .. "lastGreyE", lastGreyE, 1, true)
		elseif (context.parameters["acOutAcP"].value < 100) then
			acOutAcRetP = context.parameters["acOutAcP"].value
		end
		-- retTable["acOutAcTmpP"] = context.parameters["acOutAcP"].value
		acOutAcTmpP = context.parameters["acOutAcP"].value
		startTime = endTime
		mqtt:Publish("mqtt2", ems_prompt .. "sumGreenE", sumGreenE, 1, true)
		mqtt:Publish("mqtt2", ems_prompt .. "sumGreyE", sumGreyE, 1, true)

		if not is_today() then
			sumGreenE = 0
			sumGreyE = 0
			dayCount = 0
			lastGreenE = 0
			lastGreyE = 0
			today = os.date("*t")
			date_list.day = today.day
			date_list.month = today.month
			date_list.year = today.year
		end
	end
end

daq:OnReport(on_report)
print("MQTT Publish Tag, Event Mode")
