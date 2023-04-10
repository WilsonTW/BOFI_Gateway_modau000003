local BMS = {}

BMS.__index = BMS
BMS.Port = nil

local function GetCheckSum(buf, start, len)
  local checksum = 0;

  for idx = start, start + len - 1 do
    checksum = checksum + buf:byte(idx)
  end

  checksum = ~checksum & 0xFFFF
  checksum = (checksum + 1) & 0xFFFF
  return checksum
end
  
-------------------------------------------------------------------------------------------------
local function BuildReadDataReq(adr, pack)
  --Frame : SOI VER ADR CID1 CID2 LENGTH INFO CHECKSUM EOI
  local CID1 = "46"
  local CID2 = "42"
  local ADR = string.format("%02X", adr & 0x0F)
  local LENGTH = "E002"
  local INFO = string.format("%02X", pack & 0x0F)
  local CHECKSUM = "0000"
  local buf = "~21" .. ADR .. CID1 .. CID2 .. LENGTH .. INFO;

  CHECKSUM = string.format("%04X", GetCheckSum(buf, 2, #buf - 1))
  buf = buf .. CHECKSUM .. "\r"
  return buf
end
-------------------------------------------------------------------------------------------------
local function BuildAlarmStatusReq(adr, pack)
  --Frame : SOI VER ADR CID1 CID2 LENGTH INFO CHECKSUM EOI
  local CID1 = "46"
  local CID2 = "44"
  local ADR = string.format("%02X", adr & 0x0F)
  local LENGTH = "E002"
  local INFO = string.format("%02X", pack & 0x0F)
  local CHECKSUM = "0000"
  local buf = "~21" .. ADR .. CID1 .. CID2 .. LENGTH .. INFO;

  CHECKSUM = string.format("%04X", GetCheckSum(buf, 2, #buf - 1))
  buf = buf .. CHECKSUM .. "\r"
  return buf
end
-------------------------------------------------------------------------------------------------
function BMS:ReceivePacket()
  local err, buf, len
  local packet = ""
  local i = 0
  local state = 0
  local ch = 0

  while (i < 10 and state ~= 2) 
  do
    err, buf, len = self.Port:read(1, 100)    
    if (err ~= 0 and err ~= 9) then
      print("serial port error, " .. tostring(err) .. "\n")
      return -4, 0, nil
    end

    if (len > 0) then
      i = 1
      ch = buf:byte(1)
      if (state == 0) then
          if (ch == 0x7E) then
            state = 1
            packet = ""
          end

      elseif (state == 1) then

          if (ch == 0x0D) then
            state = 2
            break;
          end

          packet = packet .. string.char(ch)
      end
    else
      i = i + 1
    end
  end

  if (#packet == 0) then
    return -1, 0, nil  -- Timeout
  end

  if (#packet < 16) then
    return -2, 0, nil -- 封包不完整
  end

  local checksum1 = string.format("%04X", GetCheckSum(packet, 1, #packet - 4))
  local checksum2 = string.sub(packet, #packet - 3)

  if (checksum1 ~= checksum2) then
    print(checksum1 .. "  " .. checksum2)
    print("Check Sum Error\n")
    return -3, 0, nil
  end

  return 0, #packet, packet
end

-------------------------------------------------------------------------------------------------
function BMS:new()
    self = {}
    setmetatable(self, BMS)
    
    return self
end

-------------------------------------------------------------------------------------------------
function BMS:BindPort(port)
  self.Port = port
end

-------------------------------------------------------------------------------------------------
function BMS:ReadReport(pack)
  local req = BuildReadDataReq(pack, pack)
  local err, len, buf, packet
  local report = {}
  local idx;
  
  self.Port:in_queue_clear()

  err, len = self.Port:write(req)
  print("tx[" .. tostring(len) .. "] " .. req .. "\n")

  err, len, packet = self:ReceivePacket()

  if (err ~= 0) then
    -- Receive Error
    print("Error " .. tostring(err))
    return -1, nil
  end

  print("rx[" .. tostring(len) .. "] " .. packet .. "\n")

  if (len < 16) then
    return -2, nil
  end

  if (string.sub(packet, 5, 8) ~= "4600" or 
      tonumber(string.sub(packet, 3, 4), 16) ~= pack) then
    return -3, nil
  end

  report.Timestamp = os.date("!%Y-%m-%dT%H:%M:%S")

  report.PackNo = pack

  report.InfoFlag = tonumber(string.sub(packet, 13, 14), 16)

  -- Cell Voltage
  -- Voltage Unit: 1mV
  report.BatteryCellNumber = tonumber(string.sub(packet, 15, 16), 16)
  report.BatteryCellVoltages = {}
  idx = 17
  for i = 1, report.BatteryCellNumber do
    report.BatteryCellVoltages[i] = tonumber(string.sub(packet, idx, idx + 3), 16)
    idx = idx + 4
  end

  -- Temperature
  -- Temperature Unit ℃
  report.TemperatureNumber = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2

  report.Temperatures = {}
  for i = 1, report.TemperatureNumber do
    report.Temperatures[i] = tonumber(string.sub(packet, idx, idx + 3), 16)
    -- formula => value - 40 = ℃
    report.Temperatures[i] = report.Temperatures[i] - 40
    idx = idx + 4
  end  

  -- Pack

  -- Current Unit: A
  report.PackCurrent = tonumber(string.sub(packet, idx, idx + 3), 16)
  -- report.PackCurrent = tonumber(string.sub(packet, idx, idx + 3), 16) and 0xFFFF
  -- uint16 to int64
  if (report.PackCurrent >= 32768) then
    report.PackCurrent = report.PackCurrent - 65536;    
  end
  report.PackCurrent = report.PackCurrent / 100.0
  idx = idx + 4

  -- Voltage Unit: 10mV to 1mV
  report.PackVoltage = tonumber(string.sub(packet, idx, idx + 3), 16) * 10
  idx = idx + 4

  -- Current Unit: HA
  report.RemainingCapacity = tonumber(string.sub(packet, idx, idx + 3), 16) / 100.0
  idx = idx + 4

  report.P = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2

  -- Current Unit: HA
  report.FullCapacity = tonumber(string.sub(packet, idx, idx + 3), 16) / 100.0
  idx = idx + 4

  report.CycleCount = tonumber(string.sub(packet, idx, idx + 3), 16)
  idx = idx + 4
  
  report.SOC = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2  

  report.SOH = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2  

  report.Balance_01_16 = tonumber(string.sub(packet, idx, idx + 3), 16)
  idx = idx + 4

  report.Humidity = tonumber(string.sub(packet, idx, idx + 3), 16)
  idx = idx + 4

  report.Balance_17_32 = tonumber(string.sub(packet, idx, idx + 3), 16)
  idx = idx + 4
  return 0, report
end
-------------------------------------------------------------------------------------------------
function BMS:ReadAlarmStatus(pack)
  local req = BuildAlarmStatusReq(pack, pack)
  local err, len, buf, packet
  local report = {}
  local idx;
  
  self.Port:in_queue_clear()

  err, len = self.Port:write(req)
  print("tx[" .. tostring(len) .. "] " .. req .. "\n")

  err, len, packet = self:ReceivePacket()

  if (err ~= 0) then
    -- Receive Error
    print("Error " .. tostring(err))
    return -1, nil
  end

  print("rx[" .. tostring(len) .. "] " .. packet .. "\n")

  if (len < 16) then
    return -2, nil
  end

  if (string.sub(packet, 5, 8) ~= "4600" or 
      tonumber(string.sub(packet, 3, 4), 16) ~= pack) then
    return -3, nil
  end

  report.Timestamp = os.date("!%Y-%m-%dT%H:%M:%S")

  report.PackNo = pack

  report.InfoFlag = tonumber(string.sub(packet, 13, 14), 16)

  -- Cell Voltage Status
  report.BatteryCellNumber = tonumber(string.sub(packet, 15, 16), 16)
  report.BatteryCellVoltages = {}
  idx = 17
  for i = 1, report.BatteryCellNumber do
    report.BatteryCellVoltages[i] = tonumber(string.sub(packet, idx, idx + 1), 16)
    idx = idx + 2
  end

  -- Temperature Status
  report.TemperatureNumber = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2

  report.Temperatures = {}
  for i = 1, report.TemperatureNumber do
    report.Temperatures[i] = tonumber(string.sub(packet, idx, idx + 1), 16)
    idx = idx + 2
  end  

  -- Pack

  -- Current Unit: A
  report.PackCurrent = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2

  -- Voltage Unit: 10mV to 1mV
  report.PackVoltage = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2

  -- Short Circuit Protected Count
  report.ShortCircuitProtected = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2

  -- User Define Flag
  report.UserDefineFlag = tonumber(string.sub(packet, idx, idx + 1), 16)
  idx = idx + 2
  
  -- Warn Status Flag
  report.WarnStatus = {}
  for i = 1, 15 do
    report.WarnStatus[i] = tonumber(string.sub(packet, idx, idx + 1), 16)
    idx = idx + 2
  end   

  return 0, report
end

-------------------------------------------------------------------------------------------------


return BMS:new()