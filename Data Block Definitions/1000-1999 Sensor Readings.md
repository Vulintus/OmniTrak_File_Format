## File Format and Timing Data Blocks

---

* #### Block Code: 1000
  * Block Definition: AMG8833_ENABLED
  * Description: "Indicates that an AMG8833 thermopile array sensor is present in the system."
  * Status: "Used in early prototypes, can probably be safely replaced."
  * Block Format:
    * No data

---

* #### Block Code: 1001
  * Block Definition: BMP280_ENABLED,Indicates that an BMP280 temperature/pressure sensor is present in the system.,-
---

* #### Block Code: 1002
  * Block Definition: BME280_ENABLED,Indicates that an BME280 temperature/pressure/humidty sensor is present in the system.,-
---

* #### Block Code: 1003
  * Block Definition: BME680_ENABLED,Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system.,-
---

* #### Block Code: 1004
  * Block Definition: CCS811_ENABLED,Indicates that an CCS811 VOC/eC02 sensor is present in the system.,-
---

* #### Block Code: 1005
  * Block Definition: SGP30_ENABLED,Indicates that an SGP30 VOC/eC02 sensor is present in the system.,-
---

* #### Block Code: 1006
  * Block Definition: VL53L0X_ENABLED,Indicates that an VL53L0X time-of-flight distance sensor is present in the system.,-
---

* #### Block Code: 1007
  * Block Definition: ALSPT19_ENABLED,Indicates that an ALS-PT19 ambient light sensor is present in the system.,-
---

* #### Block Code: 1008,MLX90640_ENABLED,Indicates that an MLX90640 thermopile array sensor is present in the system.,-
---

* #### Block Code: 1009
  * Block Definition: ZMOD4410_ENABLED,Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system.,-

---

* #### Block Code: 1100,AMG8833_THERM_CONV,"The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.",(1x byte AMG8833 I2C address or ID) - (1x float32 conversion factor)
---

* #### Block Code: 1101,AMG8833_THERM_FL,"The current AMG8833 thermistor reading as a converted float32 value, in Celsius.",(1x byte AMG8833 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 thermistor value)
---

* #### Block Code: 1102,AMG8833_THERM_INT,"The current AMG8833 thermistor reading as a raw, signed 16-bit integer.",(1x byte AMG8833 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x int16 thermistor value)

---

* #### Block Code: 1110,AMG8833_PIXELS_CONV,"The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature.",(1x byte AMG8833 I2C address or ID) - (1x float32 conversion factor)
---

* #### Block Code: 1111,AMG8833_PIXELS_FL,"The current AMG8833 pixel readings as converted float32 values, in Celsius.",(1x byte AMG8833 I2C address or ID) - (1x uint32 millisecond timestamp) - (64x float32 pixel values)
---

* #### Block Code: 1112,AMG8833_PIXELS_INT,"The current AMG8833 pixel readings as a raw, signed 16-bit integers.",(1x byte AMG8833 I2C address or ID) - (1x uint32 millisecond timestamp) - (64x int16 pixel values)
---

* #### Block Code: 1113,HTPA32X32_PIXELS_FP62,"The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.",(1x byte HTPA32x32 I2C address or ID) - (1x uint32 millisecond timestamp) - (1024x uint8 pixel values)
---

* #### Block Code: 1114,HTPA32X32_PIXELS_INT_K,"The current HTPA32x32 pixel readings represented as 32-bit unsigned integers in units of deciKelvin (dK, or Kelvin * 10).",(1x byte HTPA32x32 I2C address or ID) - (1x uint32 millisecond timestamp) - (1024x uint32 pixel values)
---

* #### Block Code: 1115,HTPA32X32_AMBIENT_TEMP,"The current ambient temperature measured by the HTPA32x32, represented as a 32-bit float, in units of Celcius.",(1x byte HTPA32x32 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 temperature value)

---

* #### Block Code: 1120,BH1749_RGB,"The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor",(1x byte BH1749 I2C address or ID) - (1x uint32 millisecond timestamp) - (5x uint16 R/G/B/IR/G2 ADC values)
* 
---

* #### Block Code: 1121,DEBUG_SANITY_CHECK,"A special block acting as a sanity check, only used in cases of debugging","(1x uint16 number of characters) - (Nx characters ""DEBUG"")"

---

* #### Block Code: 1200,BME280_TEMP_FL,"The current BME280 temperature reading as a converted float32 value, in Celsius.",(1x byte BME280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 temperature value)
---

* #### Block Code: 1201,BMP280_TEMP_FL,"The current BMP280 temperature reading as a converted float32 value, in Celsius.",(1x byte BMP280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 temperature value)
---

* #### Block Code: 1202,BME680_TEMP_FL,"The current BME680 temperature reading as a converted float32 value, in Celsius.",(1x byte BME280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 temperature value)

---

* #### Block Code: 1210,BME280_PRES_FL,"The current BME280 pressure reading as a converted float32 value, in Pascals (Pa).",(1x byte BME280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 pressure value)
---

* #### Block Code: 1211,BMP280_PRES_FL,"The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa).",(1x byte BMP280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 pressure value)
---

* #### Block Code: 1212,BME680_PRES_FL,"The current BME680 pressure reading as a converted float32 value, in Pascals (Pa).",(1x byte BME280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 pressure value)

---

* #### Block Code: 1220,BME280_HUM_FL,"The current BM280 humidity reading as a converted float32 value, in percent (%).",(1x byte BME280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 humidity value)
---

* #### Block Code: 1221,BME680_HUM_FL,"The current BME680 humidity reading as a converted float32 value, in percent (%).",(1x byte BME680 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 humidity value)

---

* #### Block Code: 1230,BME680_GAS_FL,"The current BME680 gas resistance reading as a converted float32 value, in units of kOhms",(1x byte BME680 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 gas resistance value)

---

* #### Block Code: 1300,VL53L0X_DIST,"The current VL53L0X distance reading as a 16-bit integer, in millimeters (-1 indicates out-of-range).",(1x byte VL53L0X I2C address or ID) - (1x uint32 millisecond timestamp) - (1x int16 distance value)
---

* #### Block Code: 1301,VL53L0X_FAIL,Indicates the VL53L0X sensor experienced a range failure.,(1x byte VL53L0X I2C address or ID) - (1x uint32 millisecond timestamp)

---

* #### Block Code: 1400,SGP30_SN,The serial number of the SGP30.,(1x byte SGP30 I2C address or ID) - (3x uint16 integers)

---

* #### Block Code: 1410,SGP30_EC02,"The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm).",(1x byte SGP30 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x int16 PPM value)

---

* #### Block Code: 1420,SGP30_TVOC,"The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm).",(1x byte SGP30 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x int16 PPM value)

---

* #### Block Code: 1500,MLX90640_DEVICE_ID,The MLX90640 unique device ID saved in the device's EEPROM.,(3x uint16 device ID values)
---

* #### Block Code: 1501,MLX90640_EEPROM_DUMP,"Raw download of the entire MLX90640 EEPROM, as unsigned 16-bit integers.",(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (832x uint16 EEPROM values)
---

* #### Block Code: 1502,MLX90640_ADC_RES,"ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit).","(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint8 ADC resolution, in bits)"
---

* #### Block Code: 1503,MLX90640_REFRESH_RATE,"Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz).",(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint8 refresh rate)
---

* #### Block Code: 1504,MLX90640_I2C_CLOCKRATE,"Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz).","(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint32 I2C clockrate, in kHz)"

---

* #### Block Code: 1510,MLX90640_PIXELS_TO,"The current MLX90640 pixel readings as converted float32 values, in Celsius.",(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (768x float32 pixel values)
---

* #### Block Code: 1511,MLX90640_PIXELS_IM,"The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values.",(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (768x float32 pixel values)
---

* #### Block Code: 1512,MLX90640_PIXELS_INT,"The current MLX90640 pixel readings as a raw, unsigned 16-bit integers.",(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (834x uint16 frame data)

---

* #### Block Code: 1520,MLX90640_I2C_TIME,"The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds.",(1x byte MLX90640 I2C address or ID) - (1x uint32 start millisecond timestamp) - (1x uint32 stop millisecond timestamp)
---

* #### Block Code: 1521,MLX90640_CALC_TIME,The calculation time for the uncalibrated or calibrated image captured by the MLX90640.,(1x byte MLX90640 I2C address or ID) - (1x uint32 start millisecond timestamp) - (1x uint32 stop millisecond timestamp)
---

* #### Block Code: 1522,MLX90640_IM_WRITE_TIME,The SD card write time for the MLX90640 float32 image data.,(1x byte MLX90640 I2C address or ID) - (1x uint32 start millisecond timestamp) - (1x uint32 stop millisecond timestamp)
---

* #### Block Code: 1523,MLX90640_INT_WRITE_TIME,The SD card write time for the MLX90640 raw uint16 data.,(1x byte MLX90640 I2C address or ID) - (1x uint32 start millisecond timestamp) - (1x uint32 stop millisecond timestamp)

---

* #### Block Code: 1600,ALSPT19_LIGHT,"The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value.",(1x byte ALS-PT19 ID) - (1x uint32 millisecond timestamp) - (1x uint16 ADC value)

---

* #### Block Code: 1700,ZMOD4410_MOX_BOUND,The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.,"(1x byte ZMOD4410 I2C address or ID) - (1x uint16 lower bound ""mox_lr"") - (1x uint15 upper bound ""mox_er"")"
---

* #### Block Code: 1701,ZMOD4410_CONFIG_PARAMS,Current configuration values for the ZMOD4410.,(1x byte ZMOD4410 I2C address or ID) - (6x uint8 register values)
---

* #### Block Code: 1702,ZMOD4410_ERROR,Timestamped ZMOD4410 error event.,(1x byte ZMOD4410 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint8 error code)
---

* #### Block Code: 1703,ZMOD4410_READING_FL,Timestamped ZMOD4410 reading calibrated and converted to float32.,(1x byte ZMOD4410 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 measurement reading)
---

* #### Block Code: 1704,ZMOD4410_READING_INT,Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.,(1x byte ZMOD4410 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint16 ADC reading)

---

* #### Block Code: 1710,ZMOD4410_ECO2,Timestamped ZMOD4410 eCO2 reading.,
---

* #### Block Code: 1711,ZMOD4410_IAQ,Timestamped ZMOD4410 indoor air quality reading.,
---

* #### Block Code: 1712,ZMOD4410_TVOC,Timestamped ZMOD4410 total volatile organic compound reading.,
---

* #### Block Code: 1713,ZMOD4410_R_CDA,Timestamped ZMOD4410 total volatile organic compound reading.,

---

* #### Block Code: 1800,LSM303_ACC_SETTINGS,Current accelerometer reading settings on any enabled LSM303.,(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint32 driver version) - (1x uint32 unique identifier) - (1x float32 range maximum) - (1x float32 range minimum) - (1x float32 resolution)
1801,LSM303_MAG_SETTINGS,Current magnetometer reading settings on any enabled LSM303.,(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint32 driver version) - (1x uint32 unique identifier) - (1x float32 range maximum) - (1x float32 range minimum) - (1x float32 resolution)
---

* #### Block Code: 1802,LSM303_ACC_FL,"Current readings from the LSM303 accelerometer, as float values in m/s^2.","(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (3x float32 x, y, & z acceleration readings)"
1803,LSM303_MAG_FL,"Current readings from the LSM303 magnetometer, as float values in uT.","(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (3x float32 x, y, & z magnetometer readings)"
1804,LSM303_TEMP_FL,"Current readings from the LSM303 temperature sensor, as float value in degrees Celcius",(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 temperature reading)

1900,SPECTRO_WAVELEN,"Spectrometer wavelengths, in nanometers.",(1x byte spectrometer ID) - (1x uint32 number of wavelength values) - (Nx float32 wavelength values)
1901,SPECTRO_TRACE,Spectrometer measurement trace.,(1x byte spectrometer ID) - (1x uint8 module index) - (1x uint16 light source index) - (1x float64 serial date number) - (1x float32 light source intensity) - (1x float32 light source position) - (1x float32 integration time) - (1x boolean background subtract) - (1x uint32 number of wavelength values) - (1x uint16 number of repetitions - [Nx repetitions of (Nx float64 intensity values)]
