## File Format and Timing Data Blocks

---

| Block Code (uint16) | Definition Name | Description |
| - | - | - |
| 43981 | [OMNITRAK_FILE_VERIFY](#block-code-43981) | First unsigned 16-bit integer written to every *.OmniTrak file to identify the file type, has a hex value of 0xABCD. |
| 0 | [ERROR](#block-code-0) | **RESERVED TO INDICATE END-OF-FILE OR ERROR.** |
| 1 | [FILE_VERSION](#block-code-1) | The version of the file format used. |
| 2 | [MS_FILE_START](#block-code-2) | Value of the microcontroller millisecond clock at file creation. |
| 3 | [MS_FILE_STOP](#block-code-3) | Value of the microcontroller millisecond clock when the file is closed. |
| 4 | [SUBJECT_DEPRECATED](#block-code-4) | A single subject's name. |
| 6 | [CLOCK_FILE_START](#block-code-6) | Computer clock serial date number at file creation (local time). |
| 7 | [CLOCK_FILE_STOP](#block-code-7) | Computer clock serial date number when the file is closed (local time). |
| 10 | [DEVICE_FILE_INDEX](#block-code-10) | The device's current file index. |
| 20 | [NTP_SYNC](#block-code-20) | A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time. |
| 21 | [NTP_SYNC_FAIL](#block-code-21) | Indicates the an NTP synchonization attempt failed. |
| 22 | [CLOCK_SYNC](#block-code-22) | The current SoC microsecond clock time at the specified SoC millisecond clock time. |
| 23 | [MS_TIMER_ROLLOVER](#block-code-23) | Indicates that the millisecond timer rolled over since the last loop. |
| 24 | [US_TIMER_ROLLOVER](#block-code-24) | Indicates that the microsecond timer rolled over since the last loop. |
| 25 | [TIME_ZONE_OFFSET](#block-code-25) | Computer clock time zone offset from UTC. |
| 26 | [TIME_ZONE_OFFSET_HHMM](#block-code-26) | Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes |
| 30 | [RTC_STRING_DEPRECATED](#block-code-30) | Current date/time string from the real-time clock. |
| 31 | [RTC_STRING](#block-code-31) | Current date/time string from the real-time clock. |
| 32 | [RTC_VALUES](#block-code-32) | Current date/time values from the real-time clock. |
| 40 | [ORIGINAL_FILENAME](#block-code-40) | The original filename for the data file. |
| 41 | [RENAMED_FILE](#block-code-41) | A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs. |
| 42 | [DOWNLOAD_TIME](#block-code-42) | A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer. |
| 43 | [DOWNLOAD_SYSTEM](#block-code-43) | The computer system name and the COM port used to download the data file form the OmniTrak device. |
| 50 | [INCOMPLETE_BLOCK](#block-code-50) | Indicates that the file will end in an incomplete block. |
| 60 | [USER_TIME](#block-code-60) | Date/time values from a user-set timestamp. |

---

* #### Block Code: 43981
  * Block Definition: OMNITRAK_FILE_VERIFY<
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
  * Description: "Value of the microcontroller millisecond clock at file creation."
  * Status: "In use in deployed programs."
  * Block Format:
    * 1x (uint32): timestamp, whole number of milliseconds.

---

* #### Block Code: 3 
  * Block Definition: MS_FILE_STOP
  * Description: "Value of the microcontroller millisecond clock when the file is closed."
  * Status: "In use in deployed programs."
  * Block Format:
    * 1x (uint32): timestamp, whole number of milliseconds.

---

* #### Block Code: 4 
  * Block Definition: SUBJECT_DEPRECATED
  * Description: "A single subject's name."
  * Status: "**Deprecated**. Do not use in new programs."
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the subject name.

---

* #### Block Code: 6 
  * Block Definition: CLOCK_FILE_START
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
  * Block Definition: CLOCK_SYNC
  * Description: "The current SoC/microcontroller microsecond clock time at the specified SoC millisecond clock time."
  * Block Format:
    * 1x (uint32): SoC/microcontroller millisecond clock time.
    * 1x (uint32): SoC/microcontroller microsecond clock time.
  
---

* #### Block Code: 23
  * Block Definition: MS_TIMER_ROLLOVER
  * Description: "Indicates that the millisecond timer rolled over since the last loop."
  * Status:
  * Block Format:
    * No data
  
---

* #### Block Code: 24
  * Block Definition: US_TIMER_ROLLOVER
  * Description: "Indicates that the microsecond timer rolled over since the last loop."
  * Status:
  * Block Format:
    * No data
  
---

* #### Block Code: 25
  * Block Definition: TIME_ZONE_OFFSET
  * Description: "Computer clock time zone offset from UTC."
  * Status:
  * Block Format:
    * (float64 time zone offset as a serial date number)
  
---

* #### Block Code: 30
  * Block Definition: ~~RTC_STRING_DEPRECATED~~
  * Description: "Current date/time string from the real-time clock."
  * Status: "**Deprecated.** Do not use in new programs, use block code 31 instead. The block did not originally contain the microcontroller millisecond timestamp."
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the date/time string.
  
---

* #### Block Code: 31
  * Block Definition: RTC_STRING
  * Description: "Current date/time string from the real-time clock."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of the date/time string.
  
---

* #### Block Code: 32
  * Block Definition: RTC_VALUES
  * Description: "Current date/time values from the real-time clock."
  * Status:
  * Block Format:
    * 1x (uint **?** ): year.
    * 5x (uint8): month, day, hour, minute, and second.
  
---

* #### Block Code: 40
  * Block Definition: ORIGINAL_FILENAME
  * Description: "The original filename for the data file, recorded inside the file for reference in case the file is renamed."
  * Status:
  * Block Format:
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of original filename.
  
---

* #### Block Code: 41
  * Block Definition: RENAMED_FILE
  * Description: "A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs."
  * Status:
  * Block Format:
    * 1x (float64): MATLAB-format serial date number.
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of previous filename.
    * 1x (uint16): number of characters to follow.
    * Nx (char): characters of new filename.
  
---

* #### Block Code: 42
  * Block Definition: DOWNLOAD_TIME
  * Description: "A timestamp indicating when the data file was downloaded from a Vulintus standalone device to a computer."
  * Status:
  * Block Format:
    * 1x (float64): MATLAB-format serial date number.
  
---

* #### Block Code: 43
  * Block Definition: DOWNLOAD_SYSTEM
  * Description: "The computer system name and the COM port used to download the data file from the Vulintus standalone device."
  * Status:
  * Block Format:
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the system name.
    * 1x (uint8): number of characters to follow.
    * Nx (char): characters of the COM port name.
  
---

* #### Block Code: 50
  * Block Definition: INCOMPLETE_BLOCK
  * Description: "Indicates that the file will end in an incomplete block."
  * Status:
  * Block Format:
    * 1x (uint16): incomplete block code.
    * 1x (uint32): incomplete block start byte.
    * 1x (uint32): incomplete block end byte.
  
---

* #### Block Code: 60
  * Block Definition: USER_TIME
  * Description: "Date/time values from a user-set timestamp."
  * Status:
  * Block Format:
    * 1x (uint32): millisecond timestamp.
    * 1x (uint **?** ): year.
    * 5x (uint8): month, day, hour, minute, and second.
    
---
