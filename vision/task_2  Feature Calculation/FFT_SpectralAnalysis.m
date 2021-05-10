%% FFT Constituents
%% Load a tone file
%Copyright 2014 The MathWorks, Inc 
load two_tone.mat
%% Plot the signal in time domain
plotTimeDomain(t,x);
%% Use FFT convert time domain signal into frequency domain
% FFT output follows complex notation (a+ib) ; contains magnitude and phase
% information of the time domain signal
X = fft(x); %X is the frequency domain representation of x
%% 
x(1:3) % real input 
%%
X(1:3) % complex output
%% Retrieve the magnitude information from X
X_mag = abs(X); 
%% Retrieve the phase information from X
X_phase = angle(X);
%% Frequency bins
N = length(x);
Fbins = ((0: 1/N: 1-1/N)*Fs).'; % numel(Fbins) == 4800
%% Plot magnitude response
helperFFT(Fbins,X_mag,'Magnitude Response')
%% Plot phase response
helperFFT(Fbins,X_phase,'Phase Response') 
%%











% pwelchdemo
%% set(0,'defaultFigurePosition',[-596   489   560   420])