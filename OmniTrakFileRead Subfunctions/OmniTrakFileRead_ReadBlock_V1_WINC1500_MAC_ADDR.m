function data = OmniTrakFileRead_ReadBlock_V1_WINC1500_MAC_ADDR(fid,data)

%	OmniTrak File Block Code (OFBC):
%		150
%		WINC1500_MAC_ADDR

data = OmniTrakFileRead_Check_Field_Name(data,'device');                    %Call the subfunction to check for existing fieldnames.
data.device.mac_addr = fread(fid,6,'uint8');                                %Save the device MAC address.