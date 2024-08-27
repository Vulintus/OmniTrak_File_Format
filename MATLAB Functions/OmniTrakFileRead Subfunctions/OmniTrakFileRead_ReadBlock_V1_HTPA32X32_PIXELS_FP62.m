function session = OmniTrakFileRead_ReadBlock_V1_HTPA32X32_PIXELS_FP62(fid, session)

%	OmniTrak File Block Code (OFBC):
%		BLOCK VALUE:	1113
%		DEFINITION:		HTPA32X32_PIXELS_FP62
%		DESCRIPTION:	The current HTPA32x32 pixel readings as a fixed-point 6/2 type (6 bits for the unsigned integer part, 2 bits for the decimal part), in units of Celcius. This allows temperatures from 0 to 63.75 C.

    if (~isfield(session, 'htpa32x32_pixels_fp62'))
        session.htpa32x32_pixels_fp62 = struct( ...
            'timestamp', {}, ...
            'value', {}, ...
            'source', {} ...
        );
    end

    %Create a struct to hold the data
    thermal_data = struct( ...
        'timestamp', uint32(0), ...
        'value', double.empty, ...
        'source', uint8(0) ...
    );

    %Read in source
    thermal_data_source = fread(fid, 1, 'uint8');

    %Read in the timestamp
    thermal_data_timestamp = fread(fid, 1, 'uint32');

    %Read in 1024 bytes of thermal image data
    thermal_data_fp62 = uint8.empty;
    for i = 1:1024
        p = fread(fid, 1, 'uint8');
        thermal_data_fp62 = [thermal_data_fp62 p];
    end

    %Convert the temperature data to celsius
    thermal_data_double = Vulintus_Convert_FP62_uint8_to_double(thermal_data_fp62);

    %Reshape the temperature data to be a 32x32 matrix
    im = reshape(thermal_data_double, [32, 32]);

    %Flip the thermal data to be oriented correctly
    im = fliplr(im);

    %Set the data on the struct
    thermal_data.timestamp = thermal_data_timestamp;
    thermal_data.source = thermal_data_source;
    thermal_data.value = im;
    
    %Append the data onto the session
    session.htpa32x32_pixels_fp62 = [session.htpa32x32_pixels_fp62 thermal_data];

