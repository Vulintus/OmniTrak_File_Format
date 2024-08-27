function OmniTrakFileWrite_WriteBlock_V1_HTPA32X32_PIXELS_FP62(fid, block_code, thermal_data)
    %
    % OmniTrakFileWrite_WriteBlock_V1_HTPA32_PIXELS_FP62.m - Vulintus, Inc.
    %
    %   OmniTrakFileWrite_WriteBlock_V1_HTPA32_PIXELS_FP62 writes data from
    %   the HTPA32x32 thermal camera to the data file. This function
    %   specifically takes data formatted as FP62 (fixed-point 6/2) which
    %   fits into a uint8 data type. Fixed-point 6/2 is an 8-bit type that
    %   has 6-bit of integer resolution and 2-bits of decimal resolution.
    %
    %   UPDATE LOG:
    %   2024-08-27 - David Pruitt - Function first created.
    %

    %OmniTrak file format block code.
    fwrite(fid, block_code, 'uint16');                                          
    
    %Write the I2C address or ID
    fwrite(fid, cast(thermal_data.source, 'uint8'), 'uint8');
    
    %Write the millisecond timestamp
    fwrite(fid, cast(thermal_data.timestamp, 'uint32'), 'uint32');

    %Write the thermal image data
    for i = 4:1027
        fwrite(fid, thermal_data.value(i), 'uint8');
    end

