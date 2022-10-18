function block_codes = Load_OmniTrak_File_Block_Codes(ver)

%LOAD_OMNITRAK_FILE_BLOCK_CODES.m
%
%	Vulintus, Inc.
%
%	OmniTrak file format block code libary.
%
%	Library V1 documentation:
%	https://docs.google.com/spreadsheets/d/e/2PACX-1vSt8EQXvF5DNkU8MrZYNL_1TcYMDagQc-U6WyK51xt2nk6oHyXr6Z0jQPUfQTLzla4QNMagKPDmxKJ0/pubhtml
%
%	This function was programmatically generated: 14-Sep-2021 15:46:59
%

block_codes = [];

switch ver

	case 1
		block_codes.CUR_DEF_VERSION = 1;

