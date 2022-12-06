classdef EncryptionDemo < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        TabGroup                     matlab.ui.container.TabGroup
        WelcomeTab                   matlab.ui.container.Tab
        NEXTintro                    matlab.ui.control.Label
        introButton                  matlab.ui.control.Button
        TextArea                     matlab.ui.control.TextArea
        Startup                      matlab.ui.container.Tab
        NEXTLabel                    matlab.ui.control.Label
        age                          matlab.ui.control.NumericEditField
        WhatisyourageEditFieldLabel  matlab.ui.control.Label
        startDone                    matlab.ui.control.Button
        name                         matlab.ui.control.EditField
        WhatisyourfirstandlastnameEditFieldLabel  matlab.ui.control.Label
        Encrypt                      matlab.ui.container.Tab
        Lessthan16charactersLabel    matlab.ui.control.Label
        ENCRYPTLabel                 matlab.ui.control.Label
        Time                         matlab.ui.control.Spinner
        HowlongdoyouwanttosolveSpinnerLabel  matlab.ui.control.Label
        Button                       matlab.ui.control.Button
        EnterEncryption              matlab.ui.control.EditField
        EntertexttoEncryptLabel      matlab.ui.control.Label
        DecryptText                  matlab.ui.container.Tab
        currentGuess                 matlab.ui.control.EditField
    end

    
    properties (Access = private)
%       Creates global variables that are used throughout
        a, lcd, r2, timeToSolve, fileid;
        correctYet = false;
        shouldRun = false;
        encryptedMessage = "";
        runNum = 0;
        buffer = "";
        led1 = "D9";
        led2 = "D10";
        led3 = "D8";
        led4 = "D12";
        led5 = "D13";     
        liveguess = "";
    end

    methods (Access = private)
%       Takes in a string and returns an encrypted version by rotating
%       ASCII values
        function encStr = encryption(app,str)
%           Eliminates case and converts to a character array
            enc = char(upper(str));
            encStr = "";
%           Creates a random integer from 1 to 25
            app.r2 = randi([1 25], 1, 1);
%           Creates a for loop that cycles the length of the string setting
%           each character equal to that character modified by the random
%           integer
            for i = 1:strlength(enc)
%               If the ASCII value exceeds those of A-Z, reset the value to
%               A and cycle again
                if(enc(i) < 91 && enc(i) > 64)
                    ASCIIEnc = enc(i) + app.r2(1);
                    if(ASCIIEnc > 90)
                        ASCIIEnc = ASCIIEnc - 26;
                    end
                else
                    ASCIIEnc = enc(i);
                end
                charEnc = char(ASCIIEnc);
%               Appends the current ASCII character to the total string
                encStr = append(encStr,charEnc);
            end 
%           Returns the appended string
        end
        
        function allOn(app)
%           Turns on all LEDs
            app.a.writeDigitalPin(app.led1,1);
            app.a.writeDigitalPin(app.led2,1);
            app.a.writeDigitalPin(app.led3,1);
            app.a.writeDigitalPin(app.led4,1);
            app.a.writeDigitalPin(app.led5,1);
        end

        function allOff(app)
%           Turns off all LEDs
            app.a.writeDigitalPin(app.led1,0);
            app.a.writeDigitalPin(app.led2,0);
            app.a.writeDigitalPin(app.led3,0);
            app.a.writeDigitalPin(app.led4,0);
            app.a.writeDigitalPin(app.led5,0);
        end

        function timer(app)
%           shouldRun controls whether or not the typed message is
%           displayed on the LCD Monitor
            app.shouldRun = true;
            allOn(app);
%           start timer
            tic; 
%           Creates the time length per LED
            interval = app.Time.Value/5.0;
            
%           Runs loops while the running time is less than the time the
%           user entered
            while toc <= app.Time.Value+1
%               if the user's guess is equal to the originally entered
%               phrase
                if(app.correctYet)
%                   records the time to solve as the running time from toc
                    app.timeToSolve = toc;
                    for i = 1:10
                        allOff(app);
                        allOn(app);
                    end
                    break;
                end
%               if running time exceeds the 5th light
                if toc > 5*interval
%                   records time as 0
                    app.timeToSolve = 0;
                    app.a.writeDigitalPin(app.led5,0);
                    break;
                elseif toc > 4*interval
                    app.a.writeDigitalPin(app.led4,0);
                elseif toc > 3*interval
                    app.a.writeDigitalPin(app.led3,0);
                elseif toc > 2*interval
                    app.a.writeDigitalPin(app.led2,0);
                elseif toc > interval
                    app.a.writeDigitalPin(app.led1,0);
                end
            end
%           turns off the live displaying of guess
            app.shouldRun = false;
        end
        
        function runGame(app)
%           gets the length of the phrase
            len = strlength(app.EnterEncryption.Value);
%           creates a buffer of spaces to be used on the LCD Display
            for i = 1:16-len
                app.buffer = append(app.buffer, " ");
            end
            
%           Moves the user to the decrypting tab
            app.TabGroup.SelectedTab = app.DecryptText;
%           Automatically selects the decrypt text box
            focus(app.currentGuess);
%           Prints how many ASCII values the phrase was rotated by
            printLCD(app.lcd,char(append('Guess is ', num2str(app.r2))));
            printLCD(app.lcd,'letters back.');
            pause(2);
            timer(app);
            
%           when the user does not solve the decryption in time
            if(app.timeToSolve == 0)
                printLCD(app.lcd,'You did not     guess in time!')
            else 
                printLCD(app.lcd,'Correct!');
%               Displays the time it took the user to solve
                timeMessage = append("Time: ", num2str(app.timeToSolve,5));
                printLCD(app.lcd, char(timeMessage));
            end
%           Records the phrase, encrypted message, and time to solve to a
%           text file on the laptop
            fprintf(app.fileid, 'Phrase: %-16s\r\n',app.EnterEncryption.Value);
            fprintf(app.fileid, 'Encrypted: %-16s\r\n',app.encryptedMessage);
            fprintf(app.fileid, 'Time: %-4f\r\n \r\n',app.timeToSolve);
            pause(5);
%           when the app has ran before/gone through the game
            if app.runNum == 1
                printLCD(app.lcd,'Now please      switch sides...');
                pause(3);
                reset(app);
            else
                pause(3);
                reset(app);
                app.runNum = 0;
            end
%           saves the text in the file
            app.fileid = fclose(app.fileid);
        end
        
        function reset(app)
%               resets all necessary constants and takes the user to the 
%               welcome tab to restart the game  
                app.TabGroup.SelectedTab = app.WelcomeTab;
                app.age.Value = 0;
                app.buffer = "";
                app.liveguess = "";
                app.name.Value = "";
                app.Time.Value = 60;
                app.EnterEncryption.Value = "";
                app.encryptedMessage = "";
                app.correctYet = false;
                app.currentGuess.Value = "";
        end
    end
    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            clc;
%           Creates the arduino object
            app.a = arduino('com3', 'uno','libraries', ...
                'ExampleLCD/LCDAddon','ForceBuildOn',true);
%           Creates the LCD Object
            app.lcd = addon(app.a,'ExampleLCD/LCDAddon', ...
                'RegisterSelectedPin','D7','EnabledPin','D6', ...
                'DataPinsX',{'D5','D4','D3','D2'});

%           Calls LCD Addon library to initialize the object
            initializeLCD(app.lcd);
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
%           when the length of the entered guess is below 17 characters
            if(strlength(app.EnterEncryption.Value) < 17)
                printLCD(app.lcd,'Secret Phrase:');
%               gets the encrypted version of the user entered phrase
                app.encryptedMessage = encryption(app,app.EnterEncryption.Value);
                printLCD(app.lcd,char(app.encryptedMessage));
                pause(3);
                runGame(app);
            else
%               makes the user enter a new, shorter guess
                app.EnterEncryption.Value = "Too many characters! Try again!";
            end
        end

        % Button pushed function: startDone
        function startDonePushed(app, event)
%           records the name and age of the user as per the welcome tab to
%           the text file on the laptop
            app.fileid = fopen('userData.txt','a+');
            fprintf(app.fileid,'%-20s %2d\r\n',app.name.Value, app.age.Value);
%           moves the user to the encryption tab
            app.TabGroup.SelectedTab = app.Encrypt;
        end

        % Value changing function: currentGuess
        function currentGuessValueChanging(app, event)

            if(app.shouldRun)
%               sets global variable equal to current value of text box
                app.liveguess = event.Value;
%               if the text has letters/something has been entered
                if(~(app.liveguess == ""))
%                   creates a message to take up all 32 slots of the LCD
%                   display using the buffer
                    fullmessage = append(app.encryptedMessage, app.buffer, app.liveguess);
%                   checks if the current guess is not the originally
%                   entered phrase and it is not correct yet
                    if(~strcmpi(app.liveguess, app.EnterEncryption.Value) && ~app.correctYet)
                        if length(app.liveguess) < 17
                            printLCD(app.lcd, char(fullmessage));
                        end
                    end
%                   if the program hasnt registered correctness yet and the
%                   currently entered guess is equal to the original phrase
                    if(strcmpi(app.liveguess, app.EnterEncryption.Value) && ~app.correctYet)
                        app.correctYet = true;
                    end
                else
%                   print empty line if the user has no text
%                   entered/attempts to backspace nothing
                    printLCD(app.lcd, char(append(app.encryptedMessage,app.buffer," ")))
                end
            end
        end

        % Button pushed function: introButton
        function introButtonPushed(app, event)
%           Moves the user to the startup tab
            app.TabGroup.SelectedTab = app.Startup;
            app.runNum = app.runNum + 1;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 720 524];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [0 1 721 524];

            % Create WelcomeTab
            app.WelcomeTab = uitab(app.TabGroup);
            app.WelcomeTab.Title = 'Welcome';

            % Create TextArea
            app.TextArea = uitextarea(app.WelcomeTab);
            app.TextArea.FontName = 'Arial Black';
            app.TextArea.FontSize = 32;
            app.TextArea.Position = [23 215 675 267];
            app.TextArea.Value = {'Welcome to the Goblins Encryption Game!'; ''; 'In this simulation, you and your teammate must decode a secret message...'; ''; 'The message is up to you - when you understand click START'};

            % Create introButton
            app.introButton = uibutton(app.WelcomeTab, 'push');
            app.introButton.ButtonPushedFcn = createCallbackFcn(app, @introButtonPushed, true);
            app.introButton.Position = [240 1 215 206];
            app.introButton.Text = '';
            app.introButton.Icon = fullfile(pathToMLAPP, 'red button.jpg');

            % Create NEXTintro
            app.NEXTintro = uilabel(app.WelcomeTab);
            app.NEXTintro.FontName = 'Arial Black';
            app.NEXTintro.FontSize = 32;
            app.NEXTintro.FontColor = [1 1 1];
            app.NEXTintro.Position = [288 99 122 43];
            app.NEXTintro.Text = 'START';

            % Create Startup
            app.Startup = uitab(app.TabGroup);
            app.Startup.Title = 'Startup';
            app.Startup.BackgroundColor = [0.8392 0.8392 0.8392];

            % Create WhatisyourfirstandlastnameEditFieldLabel
            app.WhatisyourfirstandlastnameEditFieldLabel = uilabel(app.Startup);
            app.WhatisyourfirstandlastnameEditFieldLabel.HorizontalAlignment = 'right';
            app.WhatisyourfirstandlastnameEditFieldLabel.FontName = 'Arial Black';
            app.WhatisyourfirstandlastnameEditFieldLabel.FontSize = 36;
            app.WhatisyourfirstandlastnameEditFieldLabel.FontWeight = 'bold';
            app.WhatisyourfirstandlastnameEditFieldLabel.Position = [26 433 668 49];
            app.WhatisyourfirstandlastnameEditFieldLabel.Text = 'What is your first and last name?';

            % Create name
            app.name = uieditfield(app.Startup, 'text');
            app.name.FontName = 'Arial Black';
            app.name.FontSize = 24;
            app.name.Position = [43 343 634 80];

            % Create startDone
            app.startDone = uibutton(app.Startup, 'push');
            app.startDone.ButtonPushedFcn = createCallbackFcn(app, @startDonePushed, true);
            app.startDone.IconAlignment = 'center';
            app.startDone.Position = [429 67 261 262];
            app.startDone.Text = '';
            app.startDone.Icon = fullfile(pathToMLAPP, 'red button.jpg');

            % Create WhatisyourageEditFieldLabel
            app.WhatisyourageEditFieldLabel = uilabel(app.Startup);
            app.WhatisyourageEditFieldLabel.HorizontalAlignment = 'right';
            app.WhatisyourageEditFieldLabel.FontName = 'Arial Black';
            app.WhatisyourageEditFieldLabel.FontSize = 36;
            app.WhatisyourageEditFieldLabel.FontWeight = 'bold';
            app.WhatisyourageEditFieldLabel.Position = [40 280 361 49];
            app.WhatisyourageEditFieldLabel.Text = 'What is your age?';

            % Create age
            app.age = uieditfield(app.Startup, 'numeric');
            app.age.FontName = 'Arial Black';
            app.age.FontSize = 36;
            app.age.Position = [51 233 100 46];

            % Create NEXTLabel
            app.NEXTLabel = uilabel(app.Startup);
            app.NEXTLabel.FontName = 'Arial Black';
            app.NEXTLabel.FontSize = 36;
            app.NEXTLabel.FontWeight = 'bold';
            app.NEXTLabel.FontColor = [1 1 1];
            app.NEXTLabel.Position = [503 188 115 46];
            app.NEXTLabel.Text = 'NEXT';

            % Create Encrypt
            app.Encrypt = uitab(app.TabGroup);
            app.Encrypt.Title = 'Encrypt';

            % Create EntertexttoEncryptLabel
            app.EntertexttoEncryptLabel = uilabel(app.Encrypt);
            app.EntertexttoEncryptLabel.HorizontalAlignment = 'right';
            app.EntertexttoEncryptLabel.FontName = 'Arial Black';
            app.EntertexttoEncryptLabel.FontSize = 32;
            app.EntertexttoEncryptLabel.Position = [9 324 516 43];
            app.EntertexttoEncryptLabel.Text = 'What is the mystery phrase?';

            % Create EnterEncryption
            app.EnterEncryption = uieditfield(app.Encrypt, 'text');
            app.EnterEncryption.CharacterLimits = [0 1000];
            app.EnterEncryption.FontName = 'Arial Black';
            app.EnterEncryption.FontSize = 32;
            app.EnterEncryption.Position = [19 261 666 55];

            % Create Button
            app.Button = uibutton(app.Encrypt, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [71 43 219 191];
            app.Button.Text = '';
            app.Button.Icon = fullfile(pathToMLAPP, 'red button.jpg');

            % Create HowlongdoyouwanttosolveSpinnerLabel
            app.HowlongdoyouwanttosolveSpinnerLabel = uilabel(app.Encrypt);
            app.HowlongdoyouwanttosolveSpinnerLabel.HorizontalAlignment = 'right';
            app.HowlongdoyouwanttosolveSpinnerLabel.FontName = 'Arial Black';
            app.HowlongdoyouwanttosolveSpinnerLabel.FontSize = 32;
            app.HowlongdoyouwanttosolveSpinnerLabel.Position = [8 406 571 43];
            app.HowlongdoyouwanttosolveSpinnerLabel.Text = 'How long do you want to solve?';

            % Create Time
            app.Time = uispinner(app.Encrypt);
            app.Time.Step = 10;
            app.Time.Limits = [0 120];
            app.Time.FontName = 'Arial Black';
            app.Time.FontSize = 32;
            app.Time.Position = [597 404 100 41];
            app.Time.Value = 60;

            % Create ENCRYPTLabel
            app.ENCRYPTLabel = uilabel(app.Encrypt);
            app.ENCRYPTLabel.FontName = 'Arial Black';
            app.ENCRYPTLabel.FontSize = 20;
            app.ENCRYPTLabel.FontColor = [1 1 1];
            app.ENCRYPTLabel.Position = [131 141 111 27];
            app.ENCRYPTLabel.Text = 'ENCRYPT';

            % Create Lessthan16charactersLabel
            app.Lessthan16charactersLabel = uilabel(app.Encrypt);
            app.Lessthan16charactersLabel.FontName = 'Arial Black';
            app.Lessthan16charactersLabel.FontSize = 36;
            app.Lessthan16charactersLabel.Position = [317 213 522 49];
            app.Lessthan16charactersLabel.Text = '(Less than 16 characters)';

            % Create DecryptText
            app.DecryptText = uitab(app.TabGroup);
            app.DecryptText.Title = 'DecryptText';

            % Create currentGuess
            app.currentGuess = uieditfield(app.DecryptText, 'text');
            app.currentGuess.ValueChangingFcn = createCallbackFcn(app, @currentGuessValueChanging, true);
            app.currentGuess.FontName = 'Arial Black';
            app.currentGuess.FontSize = 36;
            app.currentGuess.Position = [101 83 522 346];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = EncryptionDemo

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end