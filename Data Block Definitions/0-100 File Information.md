Block Code (uint16),Definition Name,Description,Block Format


* Block Code: 43981
  * Block Definition: OMNITRAK_FILE_VERIFY
  * Description: "First unsigned 16-bit integer written to every *.OmniTrak file to identify the file type, has a hex value of 0xABCD."
  * Block Format:
    * No subsequent data.


* Block Code: 0
  * Block Definition: ERROR
  * Description: "Reserved to indicate end-of-file or an error."
  * Block Format:
    * No subsequent data.

* Block Code: 1
  * Block Definition: FILE_VERSION,The version of the file format used.,(uint16 file version)


* Block Code: 2
  * Block Definition: MS_FILE_START,Value of the SoC millisecond clock at file creation.,(uint32 timestamp) - 


* Block Code: 3
  * Block Definition: MS_FILE_STOP,Value of the SoC millisecond clock when the file is closed.,(uint32 timestamp)


* Block Code: 4,SUBJECT_DEPRECATED,A single subject's name.,(1x uint16 number of characters) - (Nx characters)
* Block Code: 6,CLOCK_FILE_START,Computer clock serial date number at file creation (local time).,(float64 serial date number)
* Block Code: 7,CLOCK_FILE_STOP,Computer clock serial date number when the file is closed (local time).,(float64 serial date number)
* Block Code: 10,DEVICE_FILE_INDEX,The device's current file index.,(uint32 index)
* Block Code: 20,NTP_SYNC,"A fetched NTP time (seconds since January 1, 1900) at the specified SoC millisecond clock time.",(uint32 NPT timestamp) - (uint32 millisecond clock time) - (uint8 # of millisecond clock rollovers since sync)
* Block Code: 21,NTP_SYNC_FAIL,Indicates the an NTP synchonization attempt failed.,-
* Block Code: 22,MS_US_CLOCK_SYNC,The current SoC microsecond clock time at the specified SoC millisecond clock time.,(uint32 millisecond clock time) - (uint32 microsecond clock time)
* Block Code: 23,MS_TIMER_ROLLOVER,Indicates that the millisecond timer rolled over since the last loop.,-
* Block Code: 24,US_TIMER_ROLLOVER,Indicates that the microsecond timer rolled over since the last loop.,-
* Block Code: 25,TIME_ZONE_OFFSET,Computer clock time zone offset from UTC.,(float64 time zone offset as a serial date number)
* Block Code: 30,RTC_STRING_DEPRECATED,Current date/time string from the real-time clock.,(1x uint16 number of characters) - (Nx characters)
* Block Code: 31,RTC_STRING,Current date/time string from the real-time clock.,(1x uint32 millisecond timestamp) - (1x uint16 number of characters) - (Nx characters)
* Block Code: 32,RTC_VALUES,Current date/time values from the real-time clock.,(1x uint32 millisecond timestamp) - (1x uint16  year) - (1x uint month) - (1x uint day) - (1x uint hour) - (1x uint minute) - (1x uint second)
* Block Code: 40,ORIGINAL_FILENAME,The original filename for the data file.,(1x uint16 number of characters) - (Nx characters of original filename)
* Block Code: 41,RENAMED_FILE,A timestamped event to indicate when a file has been renamed by one of Vulintus' automatic data organizing programs.,(1x uint64 MATLAB serial date timestamp) - (1x uint16 number of characters) - (Nx characters of previous filename) - (1x uint16 number of characters) - (Nx characters of new filename)
* Block Code: 42,DOWNLOAD_TIME,A timestamp indicating when the data file was downloaded from the OmniTrak device to a computer.,(1x uint64 MATLAB serial date timestamp)
* Block Code: 43,DOWNLOAD_SYSTEM,The computer system name and the COM port used to download the data file form the OmniTrak device.,(1x uint8 number of characters) - (Nx characters of system name) - (1x uint8 number of characters) - (Nx characters of port name)
* Block Code: 50,INCOMPLETE_BLOCK,Indicates that the file will end in an incomplete block.,(1x uint16 block code) - (1x uint32 block start byte) - (1x uint32 block end byte)
* Block Code: 60,USER_TIME,Date/time values from a user-set timestamp.,(1x uint32 millisecond timestamp) - (1x uint8 year) - (1x uint month) - (1x uint day) - (1x uint hour) - (1x uint minute) - (1x uint second)
