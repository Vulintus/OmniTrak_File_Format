## Environmental Sensor Readings Data Blocks

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
  * Description: "Indicates that an BMP280 temperature/pressure sensor is present in the system.
  * Block Format:
    * No data

---

* #### Block Code: 1002
  * Block Definition: BME280_ENABLED
  * Description: "Indicates that an BME280 temperature/pressure/humidty sensor is present in the system."
  * Block Format:
    * No data

---

* #### Block Code: 1003
  * Block Definition: BME680_ENABLED
  * Description: "Indicates that an BME680 temperature/pressure/humidy/VOC sensor is present in the system."
  * Block Format:
    * No data

---

* #### Block Code: 1004
  * Block Definition: CCS811_ENABLED
  * Description: "Indicates that an CCS811 VOC/eC02 sensor is present in the system."
  * Block Format:
    * No data

---

* #### Block Code: 1005
  * Block Definition: SGP30_ENABLED
  * Description: "Indicates that an SGP30 VOC/eC02 sensor is present in the system."
  * Block Format:
    * No data

---

* #### Block Code: 1006
  * Block Definition: VL53L0X_ENABLED
  * Description: "Indicates that an VL53L0X time-of-flight distance sensor is present in the system."
  * Block Format:
    * No data

---

* #### Block Code: 1007
  * Block Definition: ALSPT19_ENABLED
  * Description: "Indicates that an ALS-PT19 ambient light sensor is present in the system."
  * Block Format:
    * No data

---

* #### Block Code: 1008
  * Block Definition: MLX90640_ENABLED
  * Description: "Indicates that an MLX90640 thermopile array sensor is present in the system."
  * Block Format:
    * No data

---

* #### Block Code: 1009
  * Block Definition: ZMOD4410_ENABLED
  * Description: "Indicates that an ZMOD4410 VOC/eC02 sensor is present in the system."
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
    * 1x (uint8): AMG8833 I2C address or ID
    * 1x (uint32): timestamp, whole number of milliseconds.

  * Block Format:
    * (1x byte AMG8833 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 thermistor value)

---

* #### Block Code: 1102
  * Block Definition: AMG8833_THERM_INT
  * Description: "The current AMG8833 thermistor reading as a raw, signed 16-bit integer."
  * Status:
  * Block Format:
    * (1x byte AMG8833 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x int16 thermistor value)

---

* #### Block Code: 1110
  * Block Definition: AMG8833_PIXELS_CONV
  * Description: "The conversion factor, in degrees Celsius, for converting 16-bit integer AMG8833 pixel readings to temperature."
  * Status:
  * Block Format:
    * (1x byte AMG8833 I2C address or ID) - (1x float32 conversion factor)

---

* #### Block Code: 1111
  * Block Definition: AMG8833_PIXELS_FL
  * Description: "The current AMG8833 pixel readings as converted float32 values, in Celsius."
  * Status:
  * Block Format:
    * (1x byte AMG8833 I2C address or ID) - (1x uint32 millisecond timestamp) - (64x float32 pixel values)

---

* #### Block Code: 1112
  * Block Definition: AMG8833_PIXELS_INT
  * Description: "The current AMG8833 pixel readings as a raw, signed 16-bit integers."
  * Status:
  * Block Format:
    * (1x byte AMG8833 I2C address or ID) - (1x uint32 millisecond timestamp) - (64x int16 pixel values)

---

* #### Block Code: 1113
  * Block Definition: HTPA32X32_PIXELS_FP62
  * Description: "The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C."
  * Status:
  * Block Format:
    * (1x byte HTPA32x32 I2C address or ID) - (1x uint32 millisecond timestamp) - (1024x uint8 pixel values)

---

* #### Block Code: 1114
  * Block Definition: HTPA32X32_PIXELS_INT_K
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

* #### Block Code: 1120
  * Block Definition: BH1749_RGB
  * Description: "The current red, green, blue, IR, and green2 sensor readings from the BH1749 sensor"
  * Status:
  * Block Format:
    * (1x byte BH1749 I2C address or ID) - (1x uint32 millisecond timestamp) - (5x uint16 R/G/B/IR/G2 ADC values)
* 

---

* #### Block Code: 1121
  * Block Definition: DEBUG_SANITY_CHECK
  * Description: "A special block acting as a sanity check, only used in cases of debugging"
  * Status:
  * Block Format:
    * "(1x uint16 number of characters) - (Nx characters "DEBUG")"

---

* #### Block Code: 1200
  * Block Definition: BME280_TEMP_FL
  * Description: "The current BME280 temperature reading as a converted float32 value, in Celsius."
  * Status:
  * Block Format:
    * (1x byte BME280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 temperature value)

---

* #### Block Code: 1201
  * Block Definition: BMP280_TEMP_FL
  * Description: "The current BMP280 temperature reading as a converted float32 value, in Celsius."
  * Status:
  * Block Format:
    * (1x byte BMP280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 temperature value)

---

* #### Block Code: 1202
  * Block Definition: BME680_TEMP_FL
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
    * (1x byte BME280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 pressure value)

---

* #### Block Code: 1211
  * Block Definition: BMP280_PRES_FL
  * Description: "The current BMP280 pressure reading as a converted float32 value, in Pascals (Pa)."
  * Status:
  * Block Format:
    * (1x byte BMP280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 pressure value)

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
    * (1x byte BME280 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 humidity value)

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
  * Description: "The current BME680 gas resistance reading as a converted float32 value, in units of kOhms"
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
    * (1x byte VL53L0X I2C address or ID) - (1x uint32 millisecond timestamp) - (1x int16 distance value)

---

* #### Block Code: 1301
  * Block Definition: VL53L0X_FAIL
  * Description: "Indicates the VL53L0X sensor experienced a range failure.,(1x byte VL53L0X I2C address or ID) - (1x uint32 millisecond timestamp)

---

* #### Block Code: 1400
  * Block Definition: SGP30_SN
  * Description: "The serial number of the SGP30.,(1x byte SGP30 I2C address or ID) - (3x uint16 integers)

---

* #### Block Code: 1410
  * Block Definition: SGP30_EC02
  * Description: "The current SGp30 eCO2 reading distance reading as a 16-bit integer, in parts per million (ppm)."
  * Status:
  * Block Format:
    * (1x byte SGP30 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x int16 PPM value)

---

* #### Block Code: 1420
  * Block Definition: SGP30_TVOC
  * Description: "The current SGp30 TVOC reading distance reading as a 16-bit integer, in parts per million (ppm)."
  * Status:
  * Block Format:
    * (1x byte SGP30 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x int16 PPM value)

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
    * (1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (832x uint16 EEPROM values)

---

* #### Block Code: 1502
  * Block Definition: MLX90640_ADC_RES
  * Description: "ADC resolution setting on the MLX90640 (16-, 17-, 18-, or 19-bit)."
  * Status:
  * Block Format:
    * "(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint8 ADC resolution, in bits)"

---

* #### Block Code: 1503
  * Block Definition: MLX90640_REFRESH_RATE
  * Description: "Current refresh rate on the MLX90640 (0.25, 0.5, 1, 2, 4, 8, 16, or 32 Hz)."
  * Status:
  * Block Format:
    * (1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint8 refresh rate)

---

* #### Block Code: 1504
  * Block Definition: MLX90640_I2C_CLOCKRATE
  * Description: "Current I2C clock freqency used with the MLX90640 (100, 400, or 1000 kHz)."
  * Status:
  * Block Format:
    * "(1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint32 I2C clockrate, in kHz)"

---

* #### Block Code: 1510
  * Block Definition: MLX90640_PIXELS_TO
  * Description: "The current MLX90640 pixel readings as converted float32 values, in Celsius."
  * Status:
  * Block Format:
    * (1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (768x float32 pixel values)

---

* #### Block Code: 1511
  * Block Definition: MLX90640_PIXELS_IM
  * Description: "The current MLX90640 pixel readings as converted, but uncalibrationed, float32 values."
  * Status:
  * Block Format:
    * (1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (768x float32 pixel values)

---

* #### Block Code: 1512
  * Block Definition: MLX90640_PIXELS_INT
  * Description: "The current MLX90640 pixel readings as a raw, unsigned 16-bit integers."
  * Status:
  * Block Format:
    * (1x byte MLX90640 I2C address or ID) - (1x uint32 millisecond timestamp) - (834x uint16 frame data)

---

* #### Block Code: 1520
  * Block Definition: MLX90640_I2C_TIME
  * Description: "The I2C transfer time of the frame data from the MLX90640 to the microcontroller, in milliseconds."
  * Status:
  * Block Format:
    * (1x byte MLX90640 I2C address or ID) - (1x uint32 start millisecond timestamp) - (1x uint32 stop millisecond timestamp)

---

* #### Block Code: 1521
  * Block Definition: MLX90640_CALC_TIME
  * Description: "The calculation time for the uncalibrated or calibrated image captured by the MLX90640.,(1x byte MLX90640 I2C address or ID) - (1x uint32 start millisecond timestamp) - (1x uint32 stop millisecond timestamp)

---

* #### Block Code: 1522
  * Block Definition: MLX90640_IM_WRITE_TIME
  * Description: "The SD card write time for the MLX90640 float32 image data.,(1x byte MLX90640 I2C address or ID) - (1x uint32 start millisecond timestamp) - (1x uint32 stop millisecond timestamp)

---

* #### Block Code: 1523
  * Block Definition: MLX90640_INT_WRITE_TIME
  * Description: "The SD card write time for the MLX90640 raw uint16 data.,(1x byte MLX90640 I2C address or ID) - (1x uint32 start millisecond timestamp) - (1x uint32 stop millisecond timestamp)

---

* #### Block Code: 1600
  * Block Definition: ALSPT19_LIGHT
  * Description: "The current analog value of the ALS-PT19 ambient light sensor, as an unsigned integer ADC value."
  * Status:
  * Block Format:
    * (1x byte ALS-PT19 ID) - (1x uint32 millisecond timestamp) - (1x uint16 ADC value)

---

* #### Block Code: 1700
  * Block Definition: ZMOD4410_MOX_BOUND
  * Description: "The current lower and upper bounds for the ZMOD4410 ADC reading used in calculations.,"(1x byte ZMOD4410 I2C address or ID) - (1x uint16 lower bound "mox_lr") - (1x uint15 upper bound "mox_er")"

---

* #### Block Code: 1701
  * Block Definition: ZMOD4410_CONFIG_PARAMS
  * Description: "Current configuration values for the ZMOD4410.,(1x byte ZMOD4410 I2C address or ID) - (6x uint8 register values)

---

* #### Block Code: 1702
  * Block Definition: ZMOD4410_ERROR
  * Description: "Timestamped ZMOD4410 error event.,(1x byte ZMOD4410 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint8 error code)

---

* #### Block Code: 1703
  * Block Definition: ZMOD4410_READING_FL
  * Description: "Timestamped ZMOD4410 reading calibrated and converted to float32.,(1x byte ZMOD4410 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 measurement reading)

---

* #### Block Code: 1704
  * Block Definition: ZMOD4410_READING_INT
  * Description: "Timestamped ZMOD4410 reading saved as the raw uint16 ADC value.,(1x byte ZMOD4410 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint16 ADC reading)

---

* #### Block Code: 1710
  * Block Definition: ZMOD4410_ECO2
  * Description: "Timestamped ZMOD4410 eCO2 reading.,

---

* #### Block Code: 1711
  * Block Definition: ZMOD4410_IAQ
  * Description: "Timestamped ZMOD4410 indoor air quality reading.,

---

* #### Block Code: 1712
  * Block Definition: ZMOD4410_TVOC
  * Description: "Timestamped ZMOD4410 total volatile organic compound reading.,

---

* #### Block Code: 1713
  * Block Definition: ZMOD4410_R_CDA
  * Description: "Timestamped ZMOD4410 total volatile organic compound reading.,

---

* #### Block Code: 1800
  * Block Definition: LSM303_ACC_SETTINGS
  * Description: "Current accelerometer reading settings on any enabled LSM303.,(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint32 driver version) - (1x uint32 unique identifier) - (1x float32 range maximum) - (1x float32 range minimum) - (1x float32 resolution)

---

* #### Block Code: 1801
  * Block Definition: LSM303_MAG_SETTINGS
  * Description: "Current magnetometer reading settings on any enabled LSM303.,(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x uint32 driver version) - (1x uint32 unique identifier) - (1x float32 range maximum) - (1x float32 range minimum) - (1x float32 resolution)

---

* #### Block Code: 1802
  * Block Definition: LSM303_ACC_FL
  * Description: "Current readings from the LSM303 accelerometer, as float values in m/s^2."
  * Status:
  * Block Format:
    * "(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (3x float32 x, y, & z acceleration readings)"

---

* #### Block Code: 1803
  * Block Definition: LSM303_MAG_FL
  * Description: "Current readings from the LSM303 magnetometer, as float values in uT."
  * Status:
  * Block Format:
    * "(1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (3x float32 x, y, & z magnetometer readings)"

---

* #### Block Code: 1804
  * Block Definition: LSM303_TEMP_FL
  * Description: "Current readings from the LSM303 temperature sensor, as float value in degrees Celcius"
  * Status:
  * Block Format:
    * (1x byte LSM303 I2C address or ID) - (1x uint32 millisecond timestamp) - (1x float32 temperature reading)

---

* #### Block Code: 1900
  * Block Definition: SPECTRO_WAVELEN
  * Description: "Spectrometer wavelengths, in nanometers."
  * Status:
  * Block Format:
    * (1x byte spectrometer ID) - (1x uint32 number of wavelength values) - (Nx float32 wavelength values)

---

* #### Block Code: 1901
  * Block Definition: SPECTRO_TRACE
  * Description: "Spectrometer measurement trace."
  * Status:
  * Block Format:
    * (1x byte spectrometer ID) - (1x uint8 module index) - (1x uint16 light source index) - (1x float64 serial date number) - (1x float32 light source intensity) - (1x float32 light source position) - (1x float32 integration time) - (1x boolean background subtract) - (1x uint32 number of wavelength values) - (1x uint16 number of repetitions - [Nx repetitions of (Nx float64 intensity values)]

---