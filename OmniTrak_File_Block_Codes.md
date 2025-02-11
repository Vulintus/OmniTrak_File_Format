## *.OmniTrak File Block Codes (OFBC)

### Principal Data Block Code List

This is the principal list for *.OmniTrak File Block Codes (OFBC) data block codes. Values set in the following table will override and overwrite any changes made to any other file. **Edit this document first when adding new block codes.**

---

<!---The immediately following comment is necessary for programmatic library generation. DO NOT DELETE IT!--->
<!---table starts below--->
| Block Code (hex) | Block Code (uint16) | Definition Name | Description | MATLAB Scripts |
| :---: | :---: | :--- | :--- | :--- |
| - | - | - | - | - |
| 0xABCD | 43981 | OMNITRAK_FILE_VERIFY | First unsigned 16-bit integer written to every *.OmniTrak file to identify the file type, has a hex value of 0xABCD. | - |
| 0x0000 | 0 | [EOF_ERROR](#block-code-0) | **RESERVED TO INDICATE END-OF-FILE OR ERROR.** | - |
| 0x0001 | 1 | [FILE_VERSION](#block-code-1) | The version of the file format used. | - |
| 0x0002 | 2 | [MS_FILE_START](#block-code-2) | Value of the microcontroller millisecond clock at file creation. | [WRITE](MATLAB%20Functions/OmniTrakFileWrite%20Subfunctions/OmniTrakFileWrite_WriteBlock_MS_FILE_START.m)/[READ](MATLAB%20Functions/OmniTrakFileRead%20Subfunctions/OmniTrakFileRead_ReadBlock_MS_FILE_START.m) |
| | 3 | [MS_FILE_STOP](#block-code-3) | Value of the microcontroller millisecond clock when the file is closed. | |
| | 4 | [SUBJECT_DEPRECATED](#block-code-4) | A single subject's name. | |
| | 6 | [CLOCK_FILE_START](#block-code-6) | Computer clock serial date number at file creation (local time). | |
| | 7 | [CLOCK_FILE_STOP](#block-code-7) | Computer clock serial date number when the file is closed (local time). | |
| | 10 | [DEVICE_FILE_INDEX](#block-code-10) | The device's current file index. | |
| | 20 | [NTP_SYNC](#block-code-20) | A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time. | |
| | 21 | [NTP_SYNC_FAIL](#block-code-21) | Indicates the an NTP synchonization attempt failed. | |
| | 22 | [MS_US_CLOCK_SYNC](#block-code-22) | The current SoC microsecond clock time at the specified SoC millisecond clock time. | |
| | 23 | [MS_TIMER_ROLLOVER](#block-code-23) | Indicates that the millisecond timer rolled over since the last loop. | |
| | 24 | [US_TIMER_ROLLOVER](#block-code-24) | Indicates that the microsecond timer rolled over since the last loop. | |
| | 25 | [TIME_ZONE_OFFSET](#block-code-25) | Computer clock time zone offset from UTC. | |
| | 26 | [TIME_ZONE_OFFSET_HHMM](#block-code-26) | Computer clock time zone offset from UTC as two integers, one for hours, and the other for minutes |
| | 30 | [RTC_STRING_DEPRECATED](#block-code-30) | Current date/time string from the real-time clock. | |
| | 31 | [RTC_STRING](#block-code-31) | Current date/time string from the real-time clock. | |
| | 32 | [RTC_VALUES](#block-code-32) | Current date/time values from the real-time clock. | |
| | 40 | [ORIGINAL_FILENAME](#block-code-40) | The original filename for the data file. | |
| | 41 | [RENAMED_FILE](#block-code-41) | A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs. | |
| | 42 | [DOWNLOAD_TIME](#block-code-42) | A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer. | |
| | 43 | [DOWNLOAD_SYSTEM](#block-code-43) | The computer system name and the COM port used to download the data file form the OmniTrak device. | |
| | 50 | [INCOMPLETE_BLOCK](#block-code-50) | Indicates that the file will end in an incomplete block. | |
| | 60 | [USER_TIME](#block-code-60) | Date/time values from a user-set timestamp. | |