classdef LCDAddon < matlabshared.addon.LibraryBase 
    % This is an example to display a user input message on an LCD connected to arduino. 
    % It uses an LCD with HD44780 chipset to display the message 
    %
    % To begin with connect to an Arduino Uno board on COM port 3 on Windows:
    % a = arduino('COM3','Uno','Libraries','ExampleLCD/LCDAddon');
    %
    % lcd = addon(a,'ExampleLCD/LCDAddon','RegisterSelectedPin','D7','EnabledPin','D6','DataPinsX',{'D5','D4','D3','D2'});
    %
    % initializeLCD(lcd, 'Rows', 2, 'Columns', 2);
    %
    % printLCD(lcd,'Hello World!');
    %
    % clearLCD(lcd);
    %
    % <a href="matlab:helpview(arduinoio.internal.getDocMap, ''arduino_sdk'')">
    
    % Copyright 2015-2020 The MathWorks, Inc.
  
    % Define command IDs for all public methods of the class object
    properties(Access = private, Constant = true)
        LCD_CREATE     = hex2dec('00')
        LCD_INITIALIZE = hex2dec('01')
        LCD_CLEAR      = hex2dec('02')
        LCD_PRINT      = hex2dec('03')
        LCD_DELETE     = hex2dec('04')
    end 
    
    properties(SetAccess = protected)
        RegisterSelectedPin
        EnabledPin
        DataPinsX
    end
    % Include all the 3p source files
    properties(Access = protected, Constant = true)
        LibraryName = 'ExampleLCD/LCDAddon'
        DependentLibraries = {}
        LibraryHeaderFiles = 'LiquidCrystal/LiquidCrystal.h'
        CppHeaderFile = fullfile(arduinoio.FilePath(mfilename('fullpath')), 'src', 'LCD.h')
        CppClassName = 'LCD'        
    end
    
    properties(Access = private)
        ResourceOwner = 'ExampleLCD/LCDAddon';
        Rows
        Columns
    end
    
    % Create methods for each command ID to be supported by the addon
    methods(Hidden, Access = public)
        % varargin is user input and contains the pins that connect the LCD Data Pins and the arduino
        function obj = LCDAddon(parentObj,varargin)
            if(nargin < 7)
                matlabshared.hwsdk.internal.localizedError('MATLAB:narginchk:notEnoughInputs');
            elseif nargin > 7
                matlabshared.hwsdk.internal.localizedError('MATLAB:narginchk:tooManyInputs');
            end 

             try
                p = inputParser;
                addParameter(p, 'RegisterSelectedPin',[]);
                addParameter(p, 'EnabledPin', []);
                addParameter(p, 'DataPinsX', []);
                parse(p, varargin{1:end});
             catch e
                 throwAsCaller(e);
             end
            obj.Parent = parentObj;            
            obj.RegisterSelectedPin = p.Results.RegisterSelectedPin;
            obj.EnabledPin = p.Results.EnabledPin;
            obj.DataPinsX = p.Results.DataPinsX;
            inputPins = [cellstr(obj.RegisterSelectedPin) cellstr(obj.EnabledPin) obj.DataPinsX];
            count = getResourceCount(obj.Parent,obj.ResourceOwner);
            % Since this example allows implementation of only 1 LCD
            % shield, error out if resource count is more than 0
            if count > 0
                error('You can only have 1 LCD shield');
            end 
            incrementResourceCount(obj.Parent,obj.ResourceOwner);    
            createLCD(obj,inputPins);
        end
    
        function createLCD(obj,inputPins)
            try
                % Initialize command ID for each method for appropriate handling by
                % the commandHandler function in the wrapper class.
                cmdID = obj.LCD_CREATE;
                
                % Allocate the pins connected to the LCD
                for iLoop = inputPins
                    configurePinResource(obj.Parent,iLoop{:},obj.ResourceOwner,'Reserved');
                end
                
                % Call the sendCommand function to link to the appropriate method in the Cpp wrapper class
                % Define inputsX to be sent via sendCommand function. inputsX must be array of integers or empty array.
                terminals = getTerminalsFromPins(obj.Parent,inputPins);
                sendCommand(obj, obj.LibraryName, cmdID, terminals);
            catch e
                throwAsCaller(e);
            end
        end
    end
    
    methods(Access = protected)
        function delete(obj)
            try
                parentObj = obj.Parent;
                % Clear the pins that have been configured to the LCD shield
                inputPins = [cellstr(obj.RegisterSelectedPin) cellstr(obj.EnabledPin) obj.DataPinsX];
                for iLoop = inputPins
                    configurePinResource(parentObj,iLoop{:},obj.ResourceOwner,'Unset');
                end
                % Decrement the resource count for the LCD
                decrementResourceCount(parentObj, obj.ResourceOwner);
                cmdID = obj.LCD_DELETE;
                inputsX = [];
                sendCommand(obj, obj.LibraryName, cmdID, inputsX);
            catch
                % Do not throw errors on destroy.
                % This may result from an incomplete construction.
            end
        end  
    end

        
    methods(Access = public)
        % Initialize the LCD size with user specified colums and rows                                                
        function initializeLCD(obj,varargin)   
            % Using inputParser to manage inputsX to this function such that
            % it accepts row number and column number as two Name-Value
            % pair. Also, if not given, the default number for row is 2 and
            % the default number for column is 16.
            p = inputParser;
            p.PartialMatching = true;
            % If not specified, default to 2 rows and 16 columns
            addParameter(p, 'Rows', 2);
            addParameter(p, 'Columns', 16);
            parse(p, varargin{:});
            output = p.Results;
            
            obj.Rows = output.Rows;
            obj.Columns = output.Columns;
            inputsX = [output.Columns output.Rows];
            
            cmdID = obj.LCD_INITIALIZE;  
            sendCommand(obj, obj.LibraryName, cmdID, inputsX);
        end
        
        % Clear the LCD screen
        function clearLCD(obj)
            cmdID = obj.LCD_CLEAR;
            inputsX = [];
            sendCommand(obj, obj.LibraryName, cmdID, inputsX);
        end
        
        % Print the input message on the LCD
        function printLCD(obj,message)
            cmdID = obj.LCD_PRINT;
            
            if numel(message) > 32
                error('Cannot print more than 32 characters')

            elseif numel(message) > 16
                char1 = message(1:16);
                char2 = message(17:end);

                inputsX = [double(char1) obj.Columns obj.Rows];
                sendCommand(obj, obj.LibraryName, cmdID, inputsX); 
                inputsX = [double(char2) obj.Columns obj.Rows];
                sendCommand(obj, obj.LibraryName, cmdID, inputsX); 

            else
                inputsX = [double(message) obj.Columns obj.Rows];
                sendCommand(obj, obj.LibraryName, cmdID, inputsX);

            end
        
%             if numel(message) > 16
%                 error('Cannot print more than 16 characters')
%             end
%             
%             inputsX = [double(message) obj.Columns obj.Rows];
%             sendCommand(obj, obj.LibraryName, cmdID, inputsX); 
        end       
    end
end

