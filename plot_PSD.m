function plot_PSD(signal)
hPlot = subplot(2, 2, 4);
 Fs = 256;
 nfft = length(signal);        
 X_mags = fft2(signal);
 X_mags = X_mags(1:nfft/2+1);
 psdx = (1/(2*pi*nfft)) * abs(X_mags).^2;
 psdx(2:end-1) = 2*psdx(2:end-1);
 freq = 0:Fs/length(signal):Fs/2;
 
%plot(freq,10*log10(psdx)/max(10*log10(psdx)));
%pspectrum(signal,Fs,'spectrogram','FrequencyLimits', [0 600], 'TimeResolution',0.03)
% grid on
% title('Power Spectrum Density');
% xlabel('Fréquence (Hz)');
% ylabel('Puissance/Fréquence (dB/Hz)');

%%%%%%%%%%%%%%%%%%%Function PSD easy way%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hPlot = subplot(2, 2, 4);
periodogram(signal, rectwin(length(signal)), nfft, Fs, 'power')
% grid on
% title('Periodogram Using FFT')
% xlabel('Fréquence (Hz)')
% ylabel('Puissance/Fréquence (dB/Hz)')