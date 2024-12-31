% Lookup table (LUT) generator for sinusoidal PWM generation in C/C++

% Function takes in inputs for:
% The number of datapoints (not zero indexed)
% Period in radians
% Peak to peak wave height
% Positive offset for most timer systems ('y' or 'n' to enable/disable)
% Wave type of Sine or Cosine ('s' or 'c')
% Format for output ('h' or 'd' for Hex or Decimal respectively)

% Function output .rawValues stores a direct array of the generated output
% .formatted stores a formatted string with the correct datatype initializers

% The final output can be directly copy pasted into C/C++ microprocessor code
% IDE for use SPWM generation or for other functions that require a fast sine lookup.

function sinCosTable = generateSinCosTable(nData, period, peakToPeak, posOffset, wave, format)
stepSize = period/nData; % determine wave generation step size
sinCosTable.rawValues = zeros(1,nData); % initialize empty array for raw values
if wave == 's' % Sine wave generator
    fprintf('Sine wave selected \n')
    sinCosTable.formatted = sprintf('// Auto generated sine LUT from SinCosLUTGenerator.m, credit: Alec Marshall \r\n');
    if peakToPeak <= 255 && posOffset == 'y'
        sinCosTable.formatted = append(sinCosTable.formatted, sprintf('uint8_t sinTable[%d] = {\r\n', nData));
    elseif peakToPeak <= 127 && posOffset == 'n'
        sinCosTable.formatted = append(sinCosTable.formatted, sprintf('int8_t sinTable[%d] = {\r\n', nData));
    elseif peakToPeak > 255 && posOffset == 'y'
        sinCosTable.formatted = append(sinCosTable.formatted, sprintf('uint16_t sinTable[%d] = {\r\n', nData));
    elseif peakToPeak > 127 && posOffset == 'n'
        sinCosTable.formatted = append(sinCosTable.formatted, sprintf('int16_t sinTable[%d] = {\r\n', nData));
    end
    for i = 1:nData
        if posOffset == 'y'
            sinCosTable.rawValues(1,i) = round((sin(stepSize*(i-1))+1)*peakToPeak/2,0);
        elseif posOffset == 'n'
            sinCosTable.rawValues(1,i) = round(sin(stepSize*(i-1))*peakToPeak/2,0);
        else
            fprintf('Not a valid offset selection \n')
            sinCosTable.rawValues = [];
            sinCosTable.formatted = 'Not a valid offset selection';
            return
        end
        if mod(i,8) == 0
            sinCosTable.formatted = append(sinCosTable.formatted, newline);
        end
        if format == 'd'
            sinCosTable.formatted = append(sinCosTable.formatted, sprintf('%d,',sinCosTable.rawValues(i)));
        elseif format == 'h'
            sinCosTable.formatted = append(sinCosTable.formatted, sprintf('0x%X,',sinCosTable.rawValues(i)));
        else
            fprintf("Not a valid format selection \n")
            sinCosTable.rawValues = [];
            sinCosTable.formatted = 'Not a valid format selection';
            return
        end
    end
    sinCosTable.formatted = sinCosTable.formatted(1:end-1); % strip final comma
    sinCosTable.formatted = append(sinCosTable.formatted, '};');
elseif wave == 'c' % Cosine wave generator
    fprintf('Cosine wave selected \n')
    sinCosTable.formatted = sprintf('// Auto generated cosine LUT from SinCosLUTGenerator.m, credit: Alec Marshall \r\n');
    if peakToPeak <= 255 && posOffset == 'y'
        sinCosTable.formatted = append(sinCosTable.formatted, sprintf('uint8_t cosTable[%d] = {\r\n', nData));
    elseif peakToPeak <= 127 && posOffset == 'n'
        sinCosTable.formatted = append(sinCosTable.formatted, sprintf('int8_t cosTable[%d] = {\r\n', nData));
    elseif peakToPeak > 255 && posOffset == 'y'
        sinCosTable.formatted = append(sinCosTable.formatted, sprintf('uint16_t cosTable[%d] = {\r\n', nData));
    elseif peakToPeak > 127 && posOffset == 'n'
        sinCosTable.formatted = append(sinCosTable.formatted, sprintf('int16_t cosTable[%d] = {\r\n', nData));
    end
    for i = 1:nData
        if posOffset == 'y'
            sinCosTable.rawValues(1,i) = round((cos(stepSize*(i-1))+1)*peakToPeak/2,0);
        elseif posOffset == 'n'
            sinCosTable.rawValues(1,i) = round(cos(stepSize*(i-1))*peakToPeak/2,0);
        else
            fprintf('Not a valid offset selection \n')
            sinCosTable.rawValues = [];
            sinCosTable.formatted = 'Not a valid offset selection';
            return
        end
        if mod(i,8) == 0
            sinCosTable.formatted = append(sinCosTable.formatted, newline);
        end
        if format == 'd'
            sinCosTable.formatted = append(sinCosTable.formatted, sprintf('%d,',sinCosTable.rawValues(i)));
        elseif format == 'h'
            sinCosTable.formatted = append(sinCosTable.formatted, sprintf('0x%X,',sinCosTable.rawValues(i)));
        else
            fprintf("Not a valid format selection \n")
            sinCosTable.rawValues = [];
            sinCosTable.formatted = 'Not a valid format selection';
            return 
        end
    end
    sinCosTable.formatted = sinCosTable.formatted(1:end-1); % strip final comma
    sinCosTable.formatted = append(sinCosTable.formatted, '};');
else
    fprintf('Not a valid wave selection \n')
    sinCosTable.rawValues = [];
    sinCosTable.formatted = 'Not a valid wave selection';
    return
end
end

clc
posOffset = ' ';
waveType = ' ';
outFormat = ' ';
nData = 0;
pk2pk = 0;
while nData <= 0
    nData = input('Enter number of datapoints \n');
    if nData <= 0
        fprintf('Invalid number of datapoints \n')
    end
end 
period = input('Enter period (default = 2*pi) \n');
if isempty(period)
    period = 2*pi();
end
while pk2pk <= 0
    pk2pk = input('Enter peak-to-peak height \n');
    if pk2pk <= 0
        fprintf('Invalid peak to peak size \n')
    end
end
while not(posOffset == 'y') && not(posOffset == 'n')
    posOffset = input('Positive offset? (y/n) \n','s');
    if not(posOffset == 'y') && not(posOffset == 'n')
        fprintf('Invalid input, try again \n')
    end
end
while not(waveType == 'c') && not(waveType == 's')
    waveType = input('Wave type - Sine or Cosine? (c/s) \n','s');
    if not(waveType == 'c') && not(waveType == 's')
        fprintf('Invalid input, try again \n')
    end
end
if posOffset == 'y'
    while not(outFormat == 'h') && not(outFormat == 'd')
        outFormat = input('Output array format - Decimal or Hex (d/h) \n','s');
        if not(outFormat == 'h') && not(outFormat == 'd')
            fprintf('Invalid input, try again \n')
        end
    end
else
    fprintf('Hex format not possible without positive offset, defaulting to decimal')
    outFormat = 'd';
end

output = generateSinCosTable(nData, period, pk2pk, posOffset, waveType, outFormat);
plot(output.rawValues)
fprintf(output.formatted)
clipboard('copy', output.formatted);
fprintf('\n\n Output copied to clipboard \n');
