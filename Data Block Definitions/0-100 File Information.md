## File Format and Timing Data Blocks

---

* #### Block Code: 43981
  * Block Definition: OMNITRAK_FILE_VERIFY
  * Description: "First unsigned 16-bit integer written to every *.OmniTrak file to identify the file type, has a hex value of 0xABCD."
  * Status: "In use in deployed programs."
  * Block Format:
    * No data

---

* #### Block Code: 0
  * Block Definition: ERROR
  * Description: "Reserved to indicate end-of-file or an error."
  * Status: "In use in deployed programs."
  * Block Format:
    * No data

---

* #### Block Code: 1
  * Block Definition: FILE_VERSION
  * Description: "The version of the file format used."
  * Status: "In use in deployed programs."
  * Block Format:
    * 1x (uint16): file version

---

* #### Block Code: 2
  * Block Definition: MS_FILE_START
  * Description: "Value of the SoC millisecond clock at file creation."
  * Status: "In use in deployed programs."
  * Block Format:
    * 1x (uint32): timestamp, whole number of milliseconds.

---

* #### Block Code: 3
  * Block Definition: MS_FILE_STOP
  * Description: "Value of the SoC millisecond clock when the file is closed."
  * Status: "In use in deployed programs."
  * Block Format:
    * 1x (uint32): timestamp, whole number of milliseconds.

---

* #### Block Code: 4
  * Block Definition: SUBJECT_DEPRECATED
  * Description: "A single subject's name."
  * Status: "<u>Deprecated</u>. Do not use in new programs."
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the subject name.

---

* #### Block Code: 6
  * CLOCK_FILE_START
  * Description: "Computer clock serial date number at file creation (local time)."
  * Status: "In use in deployed programs."
  * Block Format:
    * 1x (float64): serial date number
    
---

* #### Block Code: 7
  * Block Definition: CLOCK_FILE_STOP
  * Description: "Computer clock serial date number when the file is closed (local time)."
  * Block Format:
    * 1x (float64): serial date number
  
---

* #### Block Code: 10
  * Block Definition: DEVICE_FILE_INDEX
  * Description: "The device's current file index."
  * Block Format:
    * 1x (uint32): file index
  
---

* #### Block Code: 20
  * Block Definition: NTP_SYNC
  * Description: "A fetched NTP time (seconds since January 1 1900) at the specified SoC/microcontroller millisecond clock time."
  * Block Format:
    * 1x (uint32): NPT timestamp
    * 1x (uint32): millisecond clock time
    * 1x (uint8): Number of millisecond clock rollovers since sync
  
---

* #### Block Code: 21
  * Block Definition: NTP_SYNC_FAIL
  * Description: "Indicates that an NTP synchonization attempt failed."
  * Block Format:
    * No data
  
---

* #### Block Code: 22
  * Block Definition: MS_US_CLOCK_SYNC
  * Description: "The current SoC/microcontroller microsecond clock time at the specified SoC millisecond clock time."
  * Block Format:
    * 1x (uint32): SoC/microcontroller millisecond clock time
    * 1x (uint32): SoC/microcontroller microsecond clock time
  
---

* #### Block Code: 23
  * Block Definition: MS_TIMER_ROLLOVER
  * Description: "Indicates that the millisecond timer rolled over since the last loop."
  * Block Format:
    * No data
  
---

* #### Block Code: 24
  * Block Definition: US_TIMER_ROLLOVER
  * Description: "Indicates that the microsecond timer rolled over since the last loop."
  * Block Format:
    * No data
  
---

* #### Block Code: 25
  * Block Definition: TIME_ZONE_OFFSET
  * Computer clock time zone offset from UTC.
  * (float64 time zone offset as a serial date number)
  
---

* #### Block Code: 30
  * Block Definition: RTC_STRING_DEPRECATED
  * Current date/time string from the real-time clock.
  * (1x uint16 number of characters) - (Nx characters)
  
---

* #### Block Code: 31
  * Block Definition: RTC_STRING
  * Current date/time string from the real-time clock.
  * (1x uint32 millisecond timestamp) - (1x uint16 number of characters) - (Nx characters)
  
---

* #### Block Code: 32
  * Block Definition: RTC_VALUES
  * Current date/time values from the real-time clock.
  * (1x uint32 millisecond timestamp) - (1x uint16  year) - (1x uint month) - (1x uint day) - (1x uint hour) - (1x uint minute) - (1x uint second)
  
---

* #### Block Code: 40
  * Block Definition: ORIGINAL_FILENAME
  * The original filename for the data file.
  * (1x uint16 number of characters) - (Nx characters of original filename)
  
---

* #### Block Code: 41
  * Block Definition: RENAMED_FILE
  * A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.
  * (1x uint64 MATLAB serial date timestamp) - (1x uint16 number of characters) - (Nx characters of previous filename) - (1x uint16 number of characters) - (Nx characters of new filename)
  
---

* #### Block Code: 42
  * Block Definition: DOWNLOAD_TIME
  * A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.
  * (1x uint64 MATLAB serial date timestamp)
  
---

* #### Block Code: 43
  * Block Definition: DOWNLOAD_SYSTEM
  * The computer system name and the COM port used to download the data file form the OmniTrak device.
  * (1x uint8 number of characters) - (Nx characters of system name) - (1x uint8 number of characters) - (Nx characters of port name)
  
---

* #### Block Code: 50
  * Block Definition: INCOMPLETE_BLOCK
  * Indicates that the file will end in an incomplete block.
  * (1x uint16 block code) - (1x uint32 block start byte) - (1x uint32 block end byte)
  
---

* #### Block Code: 60
  * Block Definition: USER_TIME
  * Date/time values from a user-set timestamp.
  * (1x uint32 millisecond timestamp) - (1x uint8 year) - (1x uint month) - (1x uint day) - (1x uint hour) - (1x uint minute) - (1x uint second)
    
---
