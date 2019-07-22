function [con] = filtered_breath_signal(timestamp,x,order)

%%%%%%%%%%%%%%%%%%%%%%%FOURIER + PASSEBAS DU SIGNAL ORIGINAL%%%%%%%%%%%%%%%%%%%%%%%%%%%

        hPlot = subplot(2, 2, 3);
        Fs = 256; %frequence d'échantillonnage
        %%%%%%%%%%%%Transformée de Fourier pour identifier la freq principale%%%%%%%%%%%%%%%
        L = length(x);   
        FT_freq = fft(x, L);
        %FT_freq = FT_freq(1:L/2);  % supprimer symétrie de FFT(domaine fréquentiel)
        freq = [0:L-1].*(Fs/L); 
        freq = freq(freq < Fs/2);  % supprimer symétrie de FFT (domaine temporel)
        Amp_time2 = ifft(FT_freq,'symmetric');  %transformée de Fourier inverse ==> la fréquence principale (signal filtré)  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        %Filtre passebas
         cut_off = 0.85/Fs/2;
         h=fir1(order,cut_off);

        %Espace temporel

         con=conv(Amp_time2,h);
         normalized_con = con/max(con);
         plot(normalized_con);
    
        xlabel('Frames');
        ylabel('Amplitude normalisée');
        title('Signal filtré filtre passe bas', 'FontSize', 16);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
%test    %filtr = designfilt('lowpassfir','PassbandFrequency',0.1, 'StopbandFrequency',0.85,'PassbandRipple',3,'StopbandAttenuation',6,'DesignMethod','kaiserwin');
%test    %d1 = designfilt('lowpassiir','FilterOrder',order, 'HalfPowerFrequency',0.15,'DesignMethod','butter');
%test    %con = filtfilt(d1,x);
%test    %plot(con);
grid on