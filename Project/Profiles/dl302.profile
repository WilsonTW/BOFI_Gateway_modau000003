{
  "Parameters": {
    "CO2": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "CO2",
        "type": "Int32",
        "rank": [],
        "source": 1,
        "address": {
          "address": "300001"
        },
        "properties": {},
        "memo": "",
        "linear": {
          "enable": false,
          "scale": 1.0,
          "base": 0
        },
        "reference": {
          "enable": false,
          "variable_id": "",
          "index": 0,
          "bit": 0,
          "length": 1
        }
      }
    },
    "RH": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "RH",
        "type": "Int32",
        "rank": [],
        "source": 1,
        "address": {
          "address": "300002"
        },
        "properties": {},
        "memo": "",
        "linear": {
          "enable": false,
          "scale": 1.0,
          "base": 0
        },
        "reference": {
          "enable": false,
          "variable_id": "",
          "index": 0,
          "bit": 0,
          "length": 1
        }
      }
    },
    "TEMP_C": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "TEMPC",
        "type": "Int32",
        "rank": [],
        "source": 1,
        "address": {
          "address": "300003"
        },
        "properties": {},
        "memo": "",
        "linear": {
          "enable": false,
          "scale": 1.0,
          "base": 0
        },
        "reference": {
          "enable": false,
          "variable_id": "",
          "index": 0,
          "bit": 0,
          "length": 1
        }
      }
    },
    "TEMP_F": {
      "$node_type$": "variable",
      "$properties$": {
        "name": "TEMP_F",
        "type": "Int32",
        "rank": [],
        "source": 1,
        "address": {
          "address": "300004"
        },
        "properties": {},
        "memo": "",
        "linear": {
          "enable": false,
          "scale": 1.0,
          "base": 0
        },
        "reference": {
          "enable": false,
          "variable_id": "",
          "index": 0,
          "bit": 0,
          "length": 1
        }
      }
    }
  },
  "Properties": {
    "StationNo": 1,
    "Endian": "little",
    "CoilMaxNum": 2000,
    "InputMaxNum": 2000,
    "HoldingRegMaxNum": 125,
    "InputRegMaxNum": 125,
    "Timeout": 1000,
    "ResponseDelay": 0,
    "RequestDelay": 0
  },
  "Driver": {
    "drive_name": "device.modbus.master",
    "filename": "device.modbus.master.drv",
    "properties": {
      "protocol": "RTU"
    }
  },
  "Information": {
    "ID": "dl302",
    "Name": "dl302",
    "Model": "Modbus",
    "Description": "",
    "ModelVersion": "1.0"
  }
}