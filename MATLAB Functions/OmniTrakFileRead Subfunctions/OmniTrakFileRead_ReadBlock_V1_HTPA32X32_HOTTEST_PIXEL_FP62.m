function session = OmniTrakFileRead_ReadBlock_V1_HTPA32X32_PIXELS_FP62(fid, session)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1117
%		DEFINITION:		HTPA32X32_HOTTEST_PIXEL_FP62
%		DESCRIPTION:	The location and temperature of the hottest pixel in the HTPA32x32 image. This may not be the raw hottest pixel. It may have gone through some processing and filtering to determine the true hottest pixel. The temperature will be in FP62 formatted Celsius.

    if (~isfield(session, 'htpa32x32_hottest_pixel_fp62'))
        session.htpa32x32_hottest_pixel_fp62 = struct( ...
            'timestamp', {}, ...
            'x', {}, ...
            'y', {}, ...
            'value', {}, ...
            'source', {} ...
        );
    end

    %Create a struct to hold the data
    thermal_data = struct( ...
        'timestamp', uint32(0), ...
        'x', 0, ...
        'y', 0, ...
        'value', 0, ...
        'source', uint8(0) ...
    );

    %Read in source
    thermal_data_source = fread(fid, 1, 'uint8');

    %Read in the timestamp
    thermal_data_timestamp = fread(fid, 1, 'uint32');

    %Read in the x location
    x_location = fread(fid, 1, 'uint8');

    %Read in the y location
    y_location = fread(fid, 1, 'uint8');

    %Read in the temperature value
    temperature_fp62 = fread(fid, 1, 'uint8');

    %Convert the temperature to Celsius
    temperature_c = Vulintus_Convert_FP62_uint8_to_double(temperature_fp62);

    %Set the data on the struct
    thermal_data.timestamp = thermal_data_timestamp;
    thermal_data.source = thermal_data_source;
    thermal_data.value = temperature_c;
    thermal_data.x = x_location;
    thermal_data.y = y_location;
    
    %Append the data onto the session
    session.htpa32x32_hottest_pixel_fp62 = [session.htpa32x32_hottest_pixel_fp62 thermal_data];

