close all;
filename = "C:\Users\sridh\Documents\MATLAB\DSP\Assignment2\audio\DSP_Recordings\Nivedita\afti1x.wav";
[signal,Fs] = readAudio(filename);
numberOfBands = 10;
bandsArray = linspace(1,4001,numberOfBands+1);
[E,Y,X] = process(signal,Fs,bandsArray);
figure;
subplot(3,1,1), plot(signal);
subplot(3,1,2), plot(X,Y), xlabel("Frequency(Hz)"), ylabel("|X(f)|");
subplot(3,1,3), plot(E), xlabel("Band Number"), ylabel("Band Energy");


function [y,Fs] = readAudio(filename)

[y,Fs] = audioread(filename);
dsampleBy = floor(Fs/8000);
Fs = Fs/dsampleBy;
y = downsample(y,dsampleBy);%%Now it is an 8kHz Signal after downsampling

end

%signal is the time domain signal 
function [energy_vec,spectrum_y,freq_x] = process(signal,Fs,bands)
energy_vec = [];
Y = fft(signal);
L = length(signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
freq_x = Fs*(0:(L/2))/L; %%Return Type
spectrum_y = P1;%%Return type

%Now we work on the energy spectrum
l = length(bands);
for i = [1:1:l-1]
    fL = bands(i);
    fH = bands(i+1);
    [B,A] = butter(3,[fL/Fs fH/Fs],'bandpass');%%Order 3, filter number 'i' 
    z = filter(B,A,signal);%%Bandpassed signal b/w fL and fH
    energy = norm(z);
    energy_vec = cat(2,energy_vec,energy);
end

end