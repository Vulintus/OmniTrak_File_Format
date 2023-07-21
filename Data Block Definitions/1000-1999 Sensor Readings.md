## Environmental Sensor Readings Data Blocks

---

| Block Code (uint16) | Definition Name | Description |
| - | - | - |
| 1000 | [AMG8833_ENABLED](#block-code-1000) | Indicates that an AMG8833 thermopile array sensor is present in the system. |
| 1001 | [BMP280_ENABLED](#block-code-1001) | Indicates that an BMP280 temperature/pressure sensor is present in the system. |
| 1002 | [BME280_ENABLED](#block-code-1002) | Indicates that an BME280 temperature/pressure/humidty sensor is present in the system. |
| 1003 | [BME680_ENABLED](#block-code-1003) | Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system. |
| 1004 | [CCS811_ENABLED](#block-code-1004) | Indicates that an CCS811 VOC/eC02 sensor is present in the system. |
| 1005 | [SGP30_ENABLED](#block-code-1005) | Indicates that an SGP30 VOC/eC02 sensor is present in the system. |
| 1006 | [VL53L0X_ENABLED](#block-code-1006) | Indicates that an VL53L0X time-of-flight distance sensor is present in the system. |
| 1007 | [ALSPT19_ENABLED](#block-code-1007) | Indicates that an ALS-PT19 ambient light sensor is present in the system. |
| 1008 | [MLX90640_ENABLED](#block-code-1008) | Indicates that an MLX90640 thermopile array sensor is present in the system. |
| 1009 | [ZMOD4410_ENABLED](#block-code-1009) | Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system. |
| 1100 | [AMG8833_THERM_CONV](#block-code-1100) | The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature. |
| 1101 | [AMG8833_THERM_FL](#block-code-1101) | The current AMG8833 thermistor reading as a converted float32 value, in Celsius. |
| 1102 | [AMG8833_THERM_INT](#block-code-1102) | The current AMG8833 thermistor reading as a raw, signed 16-bit integer. |
| 1110 | [AMG8833_PIXELS_CONV](#block-code-1110) | The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature. |
| 1111 | [AMG8833_PIXELS_FL](#block-code-1111) | The current AMG8833 pixel readings as converted float32 values, in Celsius. |
| 1112 | [AMG8833_PIXELS_INT](#block-code-1112) | The current AMG8833 pixel readings as a raw, signed 16-bit integers. |
| 1113 | [HTPA32X32_PIXELS_FP62](#block-code-1113) | The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C. |
| 1114 | [HTPA32X32_PIXELS_INT_K](#block-code-1114) | The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10). |
| 1115 | [HTPA32X32_AMBIENT_TEMP](#block-code-1115) | The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius. |
| 1116 | [HTPA32X32_PIXELS_INT12_C](#block-code-1116) | The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC). |
| 1120 | [BH1749_RGB](#block-code-1120) | The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor |
| 1121 | [DEBUG_SANITY_CHECK](#block-code-1121) | A special block acting as a sanity check, only used in cases of debugging |
| 1200 | [BME280_TEMP_FL](#block-code-1200) | The current BME280 temperature reading as a converted float32 value, in Celsius. |
| 1201 | [BMP280_TEMP_FL](#block-code-1201) | The current BMP280 temperature reading as a converted float32 value, in Celsius. |
| 1202 | [BME680_TEMP_FL](#block-code-1202) | The current BME680 temperature reading as a converted float32 value, in Celsius. |
| 1210 | [BME280_PRES_FL](#block-code-1210) | The current BME280 pressure reading as a converted float32 value, in Pascals (Pa). |
| 1211 | [BMP280_PRES_FL](#block-code-1211) | The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa). |
| 1212 | [BME680_PRES_FL](#block-code-1212) | The current BME680 pressure reading as a converted float32 value, in Pascals (Pa). |
| 1220 | [BME280_HUM_FL](#block-code-1220) | The current BM280 humidity reading as a converted float32 value, in percent (%). |
| 1221 | [BME680_HUM_FL](#block-code-1221) | The current BME680 humidity reading as a converted float32 value, in percent (%). |
| 1230 | [BME680_GAS_FL](#block-code-1230) | The current BME680 gas resistance reading as a converted float32 value, in units of kOhms |
| 1300 | [VL53L0X_DIST](#block-code-1300) | The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range). |
| 1301 | [VL53L0X_FAIL](#block-code-1301) | Indicates the VL53L0X sensor experienced a range failure. |
| 1400 | [SGP30_SN](#block-code-1400) | The serial number of the SGP30. |
| 1410 | [SGP30_EC02](#block-code-1410) | The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm). |
| 1420 | [SGP30_TVOC](#block-code-1420) | The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm). |
| 1500 | [MLX90640_DEVICE_ID](#block-code-1500) | The MLX90640 unique device ID saved in the device's EEPROM. |
| 1501 | [MLX90640_EEPROM_DUMP](#block-code-1501) | Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers. |
| 1502 | [MLX90640_ADC_RES](#block-code-1502) | ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit). |
| 1503 | [MLX90640_REFRESH_RATE](#block-code-1503) | Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz). |
| 1504 | [MLX90640_I2C_CLOCKRATE](#block-code-1504) | Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz). |
| 1510 | [MLX90640_PIXELS_TO](#block-code-1510) | The current MLX90640 pixel readings as converted float32 values, in Celsius. |
| 1511 | [MLX90640_PIXELS_IM](#block-code-1511) | The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values. |
| 1512 | [MLX90640_PIXELS_INT](#block-code-1512) | The current MLX90640 pixel readings as a raw, unsigned 16-bit integers. |
| 1520 | [MLX90640_I2C_TIME](#block-code-1520) | The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds. |
| 1521 | [MLX90640_CALC_TIME](#block-code-1521) | The calculation time for the uncalibrated or calibrated image captured by the MLX90640. |
| 1522 | [MLX90640_IM_WRITE_TIME](#block-code-1522) | The SD card write time for the MLX90640 float32 image data. |
| 1523 | [MLX90640_INT_WRITE_TIME](#block-code-1523) | The SD card write time for the MLX90640 raw uint16 data. |
| 1600 | [ALSPT19_LIGHT](#block-code-1600) | The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value. |
| 1700 | [ZMOD4410_MOX_BOUND](#block-code-1700) | The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations. |
| 1701 | [ZMOD4410_CONFIG_PARAMS](#block-code-1701) | Current configuration values for the ZMOD4410. |
| 1702 | [ZMOD4410_ERROR](#block-code-1702) | Timestamped ZMOD4410 error event. |
| 1703 | [ZMOD4410_READING_FL](#block-code-1703) | Timestamped ZMOD4410 reading calibrated and converted to float32. |
| 1704 | [ZMOD4410_READING_INT](#block-code-1704) | Timestamped ZMOD4410 reading saved as the raw uint16 ADC value. |
| 1710 | [ZMOD4410_ECO2](#block-code-1710) | Timestamped ZMOD4410 eCO2 reading. |
| 1711 | [ZMOD4410_IAQ](#block-code-1711) | Timestamped ZMOD4410 indoor air quality reading. |
| 1712 | [ZMOD4410_TVOC](#block-code-1712) | Timestamped ZMOD4410 total volatile organic compound reading. |
| 1713 | [ZMOD4410_R_CDA](#block-code-1713) | Timestamped ZMOD4410 total volatile organic compound reading. |
| 1800 | [LSM303_ACC_SETTINGS](#block-code-1800) | Current accelerometer reading settings on any enabled LSM303. |
| 1801 | [LSM303_MAG_SETTINGS](#block-code-1801) | Current magnetometer reading settings on any enabled LSM303. |
| 1802 | [LSM303_ACC_FL](#block-code-1802) | Current readings from the LSM303 accelerometer, as float values in m/s^2. |
| 1803 | [LSM303_MAG_FL](#block-code-1803) | Current readings from the LSM303 magnetometer, as float values in uT. |
| 1804 | [LSM303_TEMP_FL](#block-code-1804) | Current readings from the LSM303 temperature sensor, as float value in degrees Celcius |
| 1900 | [SPECTRO_WAVELEN](#block-code-1900) | Spectrometer wavelengths, in nanometers. |
| 1901 | [SPECTRO_TRACE](#block-code-1901) | Spectrometer measurement trace. |

---

* #### Block Code: 1000
  * Block Definition: AMG8833_ENABLED
  * Description: "Indicates that an AMG8833 thermopile array sensor is present in the system."
  * Status: "Used in early prototypes, can probably be safely replaced."
  * Block Format:
    * No data

---

* #### Block Code: 1001
  * Block Definition: BMP280_ENABLED
  * Description: "Indicates that an BMP280 temperature/pressure sensor is present in the system."
  * Status:
  * Block Format:
    * No data

---

* #### Block Code: 1002
  * Block Definition: BME280_ENABLED
  * Description: "Indicates that an BME280 temperature/pressure/humidty sensor is present in the system."
  * Status:
  * Block Format:
    * No data

---

* #### Block Code: 1003
  * Block Definition: BME680_ENABLED
  * Description: "Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system."
  * Status:
  * Block Format:
    * No data

---

* #### Block Code: 1004
  * Block Definition: CCS811_ENABLED
  * Description: "Indicates that an CCS811 VOC/eC02 sensor is present in the system."
  * Status: "The CCS811 was used in early HabiTrak prototypes, but was replaced with the BME680 early in development. This block can probably be safely replaced."
  * Block Format:
    * No data

---

* #### Block Code: 1005
  * Block Definition: SGP30_ENABLED
  * Description: "Indicates that an SGP30 VOC/eC02 sensor is present in the system."
  * Status: "Used in early prototypes, can probably be safely replaced."
  * Block Format:
    * No data

---

* #### Block Code: 1006
  * Block Definition: VL53L0X_ENABLED
  * Description: "Indicates that an VL53L0X time-of-flight distance sensor is present in the system."
  * Status:
  * Block Format:
    * No data

---

* #### Block Code: 1007
  * Block Definition: ALSPT19_ENABLED
  * Description: "Indicates that an ALS-PT19 ambient light sensor is present in the system."
  * Status:
  * Block Format:
    * No data

---

* #### Block Code: 1008
  * Block Definition: MLX90640_ENABLED
  * Description: "Indicates that an MLX90640 thermopile array sensor is present in the system."
  * Status:
  * Block Format:
    * No data

---

* #### Block Code: 1009
  * Block Definition: ZMOD4410_ENABLED
  * Description: "Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system."
  * Status:
  * Block Format:
    * No data

---

* #### Block Code: 1100
  * Block Definition: AMG8833_THERM_CONV
  * Description: "The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature."
  * Status:
  * Block Format:
    * 1x (uint8): AMG8833 I2C address or ID.
    * 1x (float32): conversion factor.

---

* #### Block Code: 1101
  * Block Definition: AMG8833_THERM_FL
  * Description: "The current AMG8833 thermistor reading as a converted float32 value, in Celsius."
  * Status:
  * Block Format:
    * 1x (uint8): AMG8833 I2C address or ID. 
    * 1x (uint32): millisecond timestamp. 
    * 1x (float32): thermistor value.

---

* #### Block Code: 1102
  * Block Definition: AMG8833_THERM_INT
  * Description: "The current AMG8833 thermistor reading as a raw, signed 16-bit integer."
  * Status:
  * Block Format:
    * 1x (uint8): AMG8833 I2C address or ID. 
    * 1x (uint32): millisecond timestamp. 
    * 1x (int16); thermistor value.

---

* #### Block Code: 1110
  * Block Definition: AMG8833_PIXELS_CONV
  * Description: "The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature."
  * Status:
  * Block Format:
    * 1x (uint8): AMG8833 I2C address or ID. 
    * 1x (float32): conversion factor.

---

* #### Block Code: 1111
  * Block Definition: AMG8833_PIXELS_FL
  * Description: "The current AMG8833 pixel readings as converted float32 values, in Celsius."
  * Status: "The AMG8833 was used in early Vulintus HabiTrak prototypes, but is not used in any current product or prototype. Vulintus may use it in future devices, however, so this block should be preserved."
  * Block Format:
    * 1x (uint8): AMG8833 I2C address or ID. 
    * 1x (uint32): millisecond timestamp.
    * 64x (float32): pixel values.

---

* #### Block Code: 1112
  * Block Definition: AMG8833_PIXELS_INT
  * Description: "The current AMG8833 pixel readings as a raw, signed 16-bit integers."
  * Status:
  * Block Format:
    * 1x (uint8): AMG8833 I2C address or ID. 
    * 1x (uint32): millisecond timestamp.
    * 64x int16 pixel values):

---

* #### Block Code: 1113
  * Block Definition: HTPA32X32_PIXELS_FP62
  * Description: "The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C."
  * Status:
  * Block Format:
    * 1x (uint8): HTPA32x32 I2C address or ID. 
    * 1x (uint32): millisecond timestamp.
    * 1024x (uint8) pixel values.

---

* #### Block Code: 1114
  * Block Definition: HTPA32X32_PIXELS_INT16_K
  * Description: "The current HTPA32x32 pixel readings represented as 16-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10)."
  * Status:
  * Block Format:
    * 1x (uint8): HTPA32x32 I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 1024x (uint16): pixel values, in deciKelvin (dK, tenths of a degree Kelvin).

---

* #### Block Code: 1115
  * Block Definition: HTPA32X32_AMBIENT_TEMP
  * Description: "The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius."
  * Status:
  * Block Format:
    * 1x (uint8): HTPA32x32 I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 1x (float32): ambient temperature value, in Celsius.

---

* #### Block Code: 116
  * Block Definition: HTPA32X32_PIXELS_INT12_C
  * Description: "The current HTPA32x32 pixel readings represented as 12-bit signed integers (2 pixels for every 3 bytes) in units of deciCelsius (dC, or Celsius * 10), with values under-range set to the minimum  (2048 dC) and values over-range set to the maximum (2047 dC)."
  * Status:
  * Block Format:
    * 1x (uint8): HTPA32x32 I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 1024x (uint12): pixel values, in deciCelsius (dC, tenths of a degree Celsius), paresed 2 pixels per 3 bytes.

---

* #### Block Code: 1120
  * Block Definition: BH1749_RGB
  * Description: "The current red, green-1, blue, near-infrared (NIR), and green-2 sensor readings from the BH1749 sensor, as raw 16-bit ADC readings."
  * Status:
  * Block Format:
    * 1x (uint8): HTPA32x32 I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 1x (uint16): red channel ADC reading.
    * 1x (uint16): green-1 channel ADC reading.
    * 1x (uint16): blue channel ADC reading.
    * 1x (uint16): near-infrared (NIR) channel ADC reading.
    * 1x (uint16): green-2 channel ADC reading.

---

* #### Block Code: 1121
  * Block Definition: DEBUG_SANITY_CHECK
  * Description: "A special block acting as a sanity check, only used in cases of debugging."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow (value should be 5).
    * Nx (char): "DEBUG."

---

* #### Block Code: 1200
  * Block Definition: BME280_TEMP_FL
  * Description: "The current BME280 temperature reading as a converted float32 value, in Celsius."
  * Status:
  * Block Format:
    * 1x (uint8): BME280 I2C address or ID. 
    * 1x (uint32): millisecond timestamp. 
    * 1x (float32): temperature value, in Celsius.

---

* #### Block Code: 1201
  * Block Definition: BMP280_TEMP_FL
  * Description: "The current BMP280 temperature reading as a converted float32 value, in Celsius."
  * Status:
  * Block Format:
    * 1x (uint8): BMP280 I2C address or ID. 
    * 1x (uint32): millisecond timestamp. 
    * 1x (float32): temperature value, in Celsius.

---

* #### Block Code: 1202
  * Block Definition: BME68X_TEMP_FL
  * Description: "The current BME680/688 temperature reading as a converted float32 value, in Celsius."
  * Status:
  * Block Format:
    * 1x (uint8): BME680/688 I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 1x (float32): ambient temperature value, in Celsius.

---

* #### Block Code: 1210
  * Block Definition: BME280_PRES_FL
  * Description: "The current BME280 pressure reading as a converted float32 value, in Pascals (Pa)."
  * Status:
  * Block Format:
    * 1x (uint8): BME280 I2C address or ID. 
    * 1x (uint32): millisecond timestamp. 
    * 1x (float32): pressure value, in Pascals.

---

* #### Block Code: 1211
  * Block Definition: BMP280_PRES_FL
  * Description: "The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa)."
  * Status:
  * Block Format:
    * 1x (uint8): BMP280 I2C address or ID. 
    * 1x (uint32): millisecond timestamp. 
    * 1x (float32): pressure value, in Pascals.

---

* #### Block Code: 1212
  * Block Definition: BME680_PRES_FL
  * Description: "The current BME680 pressure reading as a converted float32 value, in Pascals (Pa)."
  * Status:
  * Block Format:
    * 1x (uint8): BME680/688 I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 1x (float32): ambient pressure value, in Pascals.

---

* #### Block Code: 1220
  * Block Definition: BME280_HUM_FL
  * Description: "The current BM280 humidity reading as a converted float32 value, in percent (%)."
  * Status:
  * Block Format:
    * 1x (uint8) BME280 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (float32) humidity value)

---

* #### Block Code: 1221
  * Block Definition: BME680_HUM_FL
  * Description: "The current BME680 humidity reading as a converted float32 value, in percent (%)."
  * Status:
  * Block Format:
    * 1x (uint8): BME680/688 I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 1x (float32): ambient humidity value, in percent.

---

* #### Block Code: 1230
  * Block Definition: BME680_GAS_FL
  * Description: "The current BME680 gas resistance reading as a converted float32 value, in units of kOhms."
  * Status:
  * Block Format:
    * 1x (uint8): BME680/688 I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 1x (float32): gas resistance value, in kOhms.

---

* #### Block Code: 1300
  * Block Definition: VL53L0X_DIST
  * Description: "The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range)."
  * Status:
  * Block Format:
    * 1x (uint8) VL53L0X I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x ( int16 distance value)

---

* #### Block Code: 1301
  * Block Definition: VL53L0X_FAIL
  * Description: "Indicates the VL53L0X sensor experienced a range failure.,
    * 1x (uint8) VL53L0X I2C address or ID. 
    * 1x (uint32) millisecond timestamp)

---

* #### Block Code: 1400
  * Block Definition: SGP30_SN
  * Description: "The serial number of the SGP30.,
    * 1x (uint8) SGP30 I2C address or ID. (3x uint16 integers)

---

* #### Block Code: 1410
  * Block Definition: SGP30_EC02
  * Description: "The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm)."
  * Status:
  * Block Format:
    * 1x (uint8) SGP30 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x ( int16 PPM value)

---

* #### Block Code: 1420
  * Block Definition: SGP30_TVOC
  * Description: "The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm)."
  * Status:
  * Block Format:
    * 1x (uint8) SGP30 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x ( int16 PPM value)

---

* #### Block Code: 1500
  * Block Definition: MLX90640_DEVICE_ID
  * Description: "The MLX90640 unique device ID saved in the device's EEPROM.,(3x uint16 device ID values)

---

* #### Block Code: 1501
  * Block Definition: MLX90640_EEPROM_DUMP
  * Description: "Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers."
  * Status:
  * Block Format:
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. (832x uint16 EEPROM values)

---

* #### Block Code: 1502
  * Block Definition: MLX90640_ADC_RES
  * Description: "ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit)."
  * Status:
  * Block Format:
    * ."
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (uint8) ADC resolution, in bits)."

---

* #### Block Code: 1503
  * Block Definition: MLX90640_REFRESH_RATE
  * Description: "Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz)."
  * Status:
  * Block Format:
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (uint8) refresh rate)

---

* #### Block Code: 1504
  * Block Definition: MLX90640_I2C_CLOCKRATE
  * Description: "Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz)."
  * Status:
  * Block Format:
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (uint32) I2C clockrate, in kHz)."

---

* #### Block Code: 1510
  * Block Definition: MLX90640_PIXELS_TO
  * Description: "The current MLX90640 pixel readings as converted float32 values, in Celsius."
  * Status:
  * Block Format:
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) millisecond timestamp.
    * 768x (float32) pixel values.

---

* #### Block Code: 1511
  * Block Definition: MLX90640_PIXELS_IM
  * Description: "The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values."
  * Status:
  * Block Format:
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. (768x float32 pixel values)

---

* #### Block Code: 1512
  * Block Definition: MLX90640_PIXELS_INT
  * Description: "The current MLX90640 pixel readings as a raw, unsigned 16-bit integers."
  * Status:
  * Block Format:
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. (834x uint16 frame data)

---

* #### Block Code: 1520
  * Block Definition: MLX90640_I2C_TIME
  * Description: "The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds."
  * Status:
  * Block Format:
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) start millisecond timestamp. 
    * 1x (uint32) stop millisecond timestamp)

---

* #### Block Code: 1521
  * Block Definition: MLX90640_CALC_TIME
  * Description: "The calculation time for the uncalibrated or calibrated image captured by the MLX90640.,
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) start millisecond timestamp. 
    * 1x (uint32) stop millisecond timestamp)

---

* #### Block Code: 1522
  * Block Definition: MLX90640_IM_WRITE_TIME
  * Description: "The SD card write time for the MLX90640 float32 image data.,
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) start millisecond timestamp. 
    * 1x (uint32) stop millisecond timestamp)

---

* #### Block Code: 1523
  * Block Definition: MLX90640_INT_WRITE_TIME
  * Description: "The SD card write time for the MLX90640 raw uint16 data.,
    * 1x (uint8) MLX90640 I2C address or ID. 
    * 1x (uint32) start millisecond timestamp. 
    * 1x (uint32) stop millisecond timestamp)

---

* #### Block Code: 1600
  * Block Definition: ALSPT19_LIGHT
  * Description: "The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value."
  * Status:
  * Block Format:
    * 1x (uint8) ALS-PT19 ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (uint16) ADC value)

---

* #### Block Code: 1700
  * Block Definition: ZMOD4410_MOX_BOUND
  * Description: "The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can be safely replaced."
  * Block Format:
    * 1x (uint8) ZMOD4410 I2C address or ID. 
    * 1x (uint16) lower bound, "mox_lr".
    * 1x (uint15) upper bound, "mox_er".

---

* #### Block Code: 1701
  * Block Definition: ZMOD4410_CONFIG_PARAMS
  * Description: "Current configuration values for the ZMOD4410."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can be safely replaced."
  * Block Format:
    * 1x (uint8) ZMOD4410 I2C address or ID. 
    * 6x uint8 register values.

---

* #### Block Code: 1702
  * Block Definition: ZMOD4410_ERROR
  * Description: "Timestamped ZMOD4410 error event."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can be safely replaced."
  * Block Format:
    * 1x (uint8) ZMOD4410 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (uint8) error code.

---

* #### Block Code: 1703
  * Block Definition: ZMOD4410_READING_FL
  * Description: "Timestamped ZMOD4410 reading calibrated and converted to float32."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can probably be safely replaced."
  * Block Format:
    * 1x (uint8) ZMOD4410 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (float32) measurement reading)

---

* #### Block Code: 1704
  * Block Definition: ZMOD4410_READING_INT
  * Description: "Timestamped ZMOD4410 reading saved as the raw uint16 ADC value."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can probably be safely replaced."
  * Block Format:
    * 1x (uint8) ZMOD4410 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (uint16) ADC reading.

---

* #### Block Code: 1710
  * Block Definition: ZMOD4410_ECO2
  * Description: "Timestamped ZMOD4410 eCO2 reading."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can probably be safely replaced."
  * Block Format:

---

* #### Block Code: 1711
  * Block Definition: ZMOD4410_IAQ
  * Description: "Timestamped ZMOD4410 indoor air quality reading."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can probably be safely replaced."
  * Block Format:

---

* #### Block Code: 1712
  * Block Definition: ZMOD4410_TVOC
  * Description: "Timestamped ZMOD4410 total volatile organic compound reading."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can probably be safely replaced."
  * Block Format:

---

* #### Block Code: 1713
  * Block Definition: ZMOD4410_R_CDA
  * Description: "Timestamped ZMOD4410 total volatile organic compound reading."
  * Status: "Used in early Vulintus HabiTrak prototypes, the ZMOD4410 was replaced with the BME680. No sigificant data was generated with the ZMOD4410, so this block can probably be safely replaced."
  * Block Format:

---

* #### Block Code: 1800
  * Block Definition: LSM303_ACC_SETTINGS
  * Description: "Current accelerometer reading settings on any enabled LSM303."
    * 1x (uint8) LSM303 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (uint32) driver version. 
    * 1x (uint32) unique identifier. 
    * 1x (float32) range maximum. 
    * 1x (float32) range minimum. 
    * 1x (float32) resolution)

---

* #### Block Code: 1801
  * Block Definition: LSM303_MAG_SETTINGS
  * Description: "Current magnetometer reading settings on any enabled LSM303.
  * Status:
  * Block Format:
    * 1x (uint8) LSM303 I2C address or ID. 
    * 1x (uint32) millisecond timestamp. 
    * 1x (uint32) driver version. 
    * 1x (uint32) unique identifier. 
    * 1x (float32) range maximum. 
    * 1x (float32) range minimum. 
    * 1x (float32) resolution.

---

* #### Block Code: 1802
  * Block Definition: LSM303_ACC_FL
  * Description: "Current readings from the LSM303D accelerometer, as float values in m/s^2."
  * Status:
  * Block Format:
    * 1x (uint8): LSM303D I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 3x (float32): x, y, & z acceleration readings, in m/s^2.

---

* #### Block Code: 1803
  * Block Definition: LSM303_MAG_FL
  * Description: "Current readings from the LSM303D magnetometer, as float values in uT."
  * Status:
  * Block Format:
    * 1x (uint8): LSM303D I2C address or ID.
    * 1x (uint32): microcontroller timestamp, whole number of milliseconds.
    * 3x (float32): x, y, & z magnetometer readings, in uT.

---

* #### Block Code: 1804
  * Block Definition: LSM303_TEMP_FL
  * Description: "Current readings from the LSM303 temperature sensor, as float value in degrees Celsius."
  * Status:
  * Block Format:
    * 1x (uint8): LSM303 I2C address or ID. 
    * 1x (uint32): millisecond timestamp. 
    * 1x (float32): temperature reading, in Celsius.

---

* #### Block Code: 1900
  * Block Definition: SPECTRO_WAVELEN
  * Description: "Spectrometer wavelengths, in nanometers."
  * Status:
  * Block Format:
    * 1x (uint8): spectrometer ID. 
    * 1x (uint32): number of wavelength values.
    * Nx (float32) wavelength values.

---

* #### Block Code: 1901
  * Block Definition: SPECTRO_TRACE
  * Description: "Spectrometer measurement trace."
  * Status:
  * Block Format:
    * 1x (uint8): spectrometer ID. 
    * 1x (uint8): module index. 
    * 1x (uint16): light source index. 
    * 1x (float64): serial date number. 
    * 1x (float32): light source intensity. 
    * 1x (float32): light source position. 
    * 1x (float32): integration time. 
    * 1x ( boolean background subtract. 
    * 1x (uint32): number of wavelength values. 
    * 1x (uint16): number of repetitions.
    * Nx (float64) intensity values.

---
