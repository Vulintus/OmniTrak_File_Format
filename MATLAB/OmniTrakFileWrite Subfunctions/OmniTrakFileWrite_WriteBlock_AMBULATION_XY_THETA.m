function OmniTrakFileWrite_WriteBlock_AMBULATION_XY_THETA(fid, block_code, timestamp, xy, angle)

%
% OmniTrakFileWrite_WriteBlock_AMBULATION_XY_THETA.m
%   
%   copyright 2025, Vulintus, Inc.
%
%   OMNITRAKFILEWRITE_WRITEBLOCK_AMBULATION_XY_THETA writes a point in a
%   ambulation tracking path, measured by either a set of optical flow
%   sensors, like on the spherical treadmill, or by overhead video
%   tracking. The save path point consists of absolute x- and 
%   y-coordinates,in millimeters, and the animal's front-facing direction 
%   theta, in degrees.
%
%   OFBC block code: 0x0400
%
%   UPDATE LOG:
%   2025-02-10 - Drew Sloan - Function first created.
%

data_block_version = 1;                                                     %Set the AMBULATION_XY_THETA block version.

fwrite(fid,block_code,'uint16');                                            %OmniTrak file format block code.
fwrite(fid,data_block_version,'uint8');                                     %Write the AMBULATION_XY_THETA block version.

fwrite(fid, timestamp, 'uint32');                                           %Path point timestamp (microsecond clock reading).
fwrite(fid, xy, 'float32');                                                 %Write the x- and y-coordinates, as single-precision floats.
fwrite(fid, angle, 'float32');                                              %Write the front facing direction, in degrees.