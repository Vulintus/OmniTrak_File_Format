## Operant Behavior Data Blocks

---

* #### Block Code: 2000
  * Block Definition: PELLET_DISPENSE
  * Description: "Timestamped event for feeding/pellet dispensing."
  * Status: "In use in deployed programs."
  * Block Format:
    * 1x (uint32): millisecond timestamp
    * 1x (uint8): dispenser index
    * 1x (uint16): trial number

---
2001,PELLET_FAILURE,Timestamped event for feeding/pellet dispensing in which no pellet was detected.,(1x uint32 millisecond timestamp) - (1x uint8 dispenser index)

2010,HARD_PAUSE_START,"Timestamped event marker for the start of a session pause, with no events recorded during the pause.",(1x uint32 millisecond timestamp)
2011,HARD_PAUSE_START,"Timestamped event marker for the stop of a session pause, with no events recorded during the pause.",(1x uint32 millisecond timestamp)
2012,SOFT_PAUSE_START,"Timestamped event marker for the start of a session pause, with non-operant events recorded during the pause.",(1x uint32 millisecond timestamp)
2013,SOFT_PAUSE_START,"Timestamped event marker for the stop of a session pause, with non-operant events recorded during the pause.",(1x uint32 millisecond timestamp)

2020,POSITION_START_X,"Starting position of an autopositioner in just the x-direction, with distance in millimeters.",(1x uint8 autopositioner index) - (1x float32 distance x-value)
2021,POSITION_MOVE_X,"Timestamped movement of an autopositioner in just the x-direction, with distance in millimeters.",(1x uint32 millisecond timestamp) - (1x uint8 autopositioner index) - (1x float32 distance x-value)
2022,POSITION_START_XY,"Starting position of an autopositioner in just the x- and y-directions, with distance in millimeters.",(1x uint8 autopositioner index) - (1x float32 distance x-value) - (1x float32 distance y-value)
2023,POSITION_MOVE_XY,"Timestamped movement of an autopositioner in just the x- and y-directions, with distance in millimeters.",(1x uint32 millisecond timestamp) - (1x uint8 autopositioner index) - (1x float32 distance x-value) - (1x float32 distance y-value)
2024,POSITION_START_XYZ,"Starting position of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.",(1x uint8 autopositioner index) - (1x float32 distance x-value) - (1x float32 distance y-value) - (1x float32 distance z-value)
2025,POSITION_MOVE_XYZ,"Timestamped movement of an autopositioner in the x-, y-, and z- directions, with distance in millimeters.",(1x uint32 millisecond timestamp) - (1x uint8 autopositioner index) - (1x float32 distance x-value) - (1x float32 distance y-value) - (1x float32 distance z-value)

2100,STREAM_INPUT_NAME,Stream input name for the specified input index.,(1x uint8 input index) - (1x uint8 number of characters) - (Nx characters)

2200,CALIBRATION_BASELINE,"Starting calibration baseline coefficient, for the specified module index.",(1x uint8 module index) - (1x float32 coefficient value)
2201,CALIBRATION_SLOPE,"Starting calibration slope coefficient, for the specified module index.",(1x uint8 module index) - (1x float32 coefficient value)
2202,CALIBRATION_BASELINE_ADJUST,"Timestamped in-session calibration baseline coefficient adjustment, for the specified module index.",(1x uint32 millisecond timestamp) - (1x uint8 module index) - (1x float32 coefficient value)
2203,CALIBRATION_SLOPE_ADJUST,"Timestamped in-session calibration slope coefficient adjustment, for the specified module index.",(1x uint32 millisecond timestamp) - (1x uint8 module index) - (1x float32 coefficient value)

2300,HIT_THRESH_TYPE,"Type of hit threshold (i.e. peak force), for the specified input.",(1x uint8 input index) - (1x uint16 number of characters) - (Nx characters)

2310,SECONDARY_THRESH_NAME,A name/description of secondary thresholds used in the behavior.,(1x uint8 secondary threshold index) - (1x uint8 number of characters) - (Nx characters)

2320,INIT_THRESH_TYPE,"Type of initation threshold (i.e. force or touch), for the specified input.",(1x uint8 input index) - (1x uint16 number of characters) - (Nx characters)

2400,REMOTE_MANUAL_FEED,"A timestamped manual feed event, triggered remotely.",(1x uint8 dispenser index) - (1x uint32 millisecond timestamp) - (1x uint16 number of feedings)
2401,HWUI_MANUAL_FEED,"A timestamped manual feed event, triggered from the hardware user interface.",(1x uint8 dispenser index) - (1x uint32 millisecond timestamp) - (1x uint16 number of feedings)
2402,FW_RANDOM_FEED,"A timestamped manual feed event, triggered randomly by the firmware.",(1x uint8 dispenser index) - (1x uint32 millisecond timestamp) - (1x uint16 number of feedings)
2403,SWUI_MANUAL_FEED_DEPRECATED,"A timestamped manual feed event, triggered from a computer software user interface.",(1x float64 serial date number) - (1x uint8 dispenser index)
2404,FW_OPERANT_FEED,"A timestamped operant-rewarded feed event, trigged by the OmniHome firmware, with the possibility of multiple feedings.",(1x uint8 dispenser index) - (1x uint32 millisecond timestamp) - (1x uint16 number of feedings)
2405,SWUI_MANUAL_FEED,"A timestamped manual feed event, triggered from a computer software user interface.",(1x uint8 dispenser index) - (1x float64 serial date number) - (1x uint16 number of feedings)
2406,SW_RANDOM_FEED,"A timestamped manual feed event, triggered randomly by computer software.",(1x uint8 dispenser index) - (1x float64 serial date number) - (1x uint16 number of feedings)
2407,SW_OPERANT_FEED,"A timestamped operant-rewarded feed event, trigged by the PC-based behavioral software, with the possibility of multiple feedings.",(1x uint8 dispenser index) - (1x float64 serial date number) - (1x uint16 number of feedings)

2500,MOTOTRAK_V3P0_OUTCOME,MotoTrak version 3.0 trial outcome data.,(1x uint16 trial number) - (1x uint32 millisecond trial start timestamp) - (1x uchar outcome code) - (1x uint16 pre-trial samples) - (1x uint16 hit window samples) - (1x uint16 post-trial samples) - (1x float32 initiation threshold) - (1x float32 hit threshold) - (1x uint8 number of secondary thresholds) - (Nx float32 secondary thresholds) - (1x uint8 number of hits) - (Nx uint32 millisecond hit timestamps) - (1x uint8 number of output triggers) - [Nx (1x uint8 trigger index) - (1x uint32 millisecond hit timestamps)] - (1x uint16 post-trial samples) - (1x uint8 number of signal streams) - [Nx (1x uint32 timestamp) - (Nx int16t signal samples)]
2501,MOTOTRAK_V3P0_SIGNAL,MotoTrak version 3.0 trial stream signal.,(1x uint16 trial number) - (1x uint32 hit window samples) - (1x uint16 post-trial samples) - (1x uint8 number of signal streams) - [Nx (1x uint32 timestamp) - (Nx int16t signal samples)]

2600,OUTPUT_TRIGGER_NAME,Name/description of the output trigger type for the given index.,(1x uint8 trigger index) - (1x uint8 number of characters) - (Nx characters)

2700,VIBRATION_TASK_TRIAL_OUTCOME,Vibration task trial outcome data.,

2710,LED_DETECTION_TASK_TRIAL_OUTCOME,LED detection task trial outcome data.,
2711,LIGHT_SRC_MODEL,Light source model name.,(1x uint8 module index) - (1x uint16 light source index) - (1x uint8 number of characters) - (Nx characters)
2712,LIGHT_SRC_TYPE,"Light source type (i.e. LED, LASER, etc).",(1x uint8 module index) - (1x uint16 light source index) - (1x uint8 number of characters) - (Nx characters)

2720,STTC_2AFC_TRIAL_OUTCOME,SensiTrak tactile discrimination task trial outcome data.,
2721,STTC_NUM_PADS,Number of pads on the SensiTrak Tactile Carousel module.,(1x uint8 module index) - (1x uint8 number of pads)
2722,MODULE_MICROSTEP,Microstep setting on the specified OTMP module.,(1x uint8 module index) - (1x uint8 microstep setting)
2723,MODULE_STEPS_PER_ROT,Steps per rotation on the specified OTMP module.,(1x uint8 module index) - (1x uint16 microstep setting)

2730,MODULE_PITCH_CIRC,"Pitch circumference, in millimeters, of the driving gear on the specified OTMP module.","(1x uint8 module index) - (1x float32 circumference, in millimeters)"
2731,MODULE_CENTER_OFFSET,"Center offset, in millimeters, for the specified OTMP module.","(1x uint8 module index) - (1x float32 center offset, in millimeters)"

2740,STAP_2AFC_TRIAL_OUTCOME,SensiTrak proprioception discrimination task trial outcome data.,
