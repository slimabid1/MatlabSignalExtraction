function [breath_cycle] = nb_cycles_respiration(convoluted_signal, order, durationVideo)

%Suite à la convolution du signal (using FFT & LowPass Filter)

%%%%%%%%%%%%%%%%%%%%%%%Compteur du nombre de cycles respiratoires%%%%%%%%%%%%%

dcon=diff(convoluted_signal); %dérivée du signal filtré (entré en paramètre)
change_sign = find(dcon(order+1:end-order-1)>0 & dcon(order+2:end-order) < 0);
breath_cycle = length(change_sign);
bpm = breath_cycle/durationVideo*60; %Breathes per minute ==> 60 sec.
bpm = round(bpm);
fprintf('Le sujet a fait %d cycles respiratoires.\n',breath_cycle);
m = sprintf('Le sujet a un rythme respiratoire de %d respiration par minute.',bpm);
uiwait(helpdlg(m));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
