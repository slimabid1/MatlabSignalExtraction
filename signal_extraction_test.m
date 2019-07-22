clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 16;

order = 40; %utilisé dans le filtre passe bas.

%%%%%%%%%%%%%%%%%%%%%%%%%%Partie réservée à l'aquisition de la vidéo%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vid_path = 'C:/Users/slabid/Desktop/Code_and_Dataset/Matlab_Signal_Extraction/FLIROne/trials/1.mp4';
[folder, vid_name, ext] = fileparts(vid_path);
% vid_cropped_path = crop_video(folder, vid_name, ext);
% [vid_cropped_folder, vid_cropped_name, vid_cropped_ext] = fileparts(vid_cropped_path);
% movieFullFileName = fullfile(folder,strcat(vid_cropped_name, vid_cropped_ext));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Original Video ==> to get the real duration for BPM calculation%%%
movieFullFileName0 = fullfile(folder,strcat(vid_name,ext));
videoObject = VideoReader(movieFullFileName0);
duration0 = videoObject.Duration;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder = 'C:/Users/slabid/Desktop/Code_and_Dataset/Matlab_Signal_Extraction/';
movieFullFileName = fullfile(folder,'Cropped_1.mp4');
% Check to see that it exists.
if ~exist(movieFullFileName, 'file')
	strErrorMessage = sprintf('File not found:\n%s\nYou can choose a new one, or cancel', movieFullFileName);
	response = questdlg(strErrorMessage, 'Fichier pas trouvé.', 'OK - choisir un autre fichier.', 'Annuler', 'OK - choisir un nouveau fichier.');
	if strcmpi(response, 'OK - choisir une autre video.')
		[baseFileName, folderName, FilterIndex] = uigetfile('*.mp4');
		if ~isequal(baseFileName, 0)
			movieFullFileName = fullfile(folderName, baseFileName);
		else
			return;
		end
	else
		return;
	end
end

try
	videoObject = VideoReader(movieFullFileName);

    frame_rate = videoObject.FrameRate;
    duration = videoObject.Duration;
    
	% Détermine le nombre de frame dans la vidéo.
	numberOfFrames = videoObject.NumberOfFrames;
	vidHeight = videoObject.Height;
	vidWidth = videoObject.Width;
	
	numberOfFramesWritten = 0;
	
	% Loop through the movie, writing all frames out.
	% Each frame will be in a separate file with unique name.
	meanGrayLevels = zeros(numberOfFrames, 1);
    timestamp = zeros(numberOfFrames, 1);
	for frame = 1 : numberOfFrames %duration non pas nbr of frames cuz we using 30 frames each iteration
		% Extract the frame from the movie structure.
		thisFrame = read(videoObject, frame);%readFrame
        videoFrameGray = rgb2gray(thisFrame);
%         %%HERE INSERT THE NOSTRIL TRACKING FUNCTION <=======================================================
         %nostril_tracking(videoFrameGray);
        % Display it
      	hImage = subplot(2, 2, 1);
		caption = sprintf('Frame %4d de %d.', frame, numberOfFrames);
		title(caption, 'FontSize', fontSize);
		drawnow; % Force it to refresh the window.

        
		% Calculate the mean gray level.
		grayImage = rgb2gray(thisFrame);
		meanGrayLevels(frame) = mean(grayImage(:));
		imshow(grayImage);
        
		%Graph X = temps VS Y = niveaux de gris moyen du frame rogné
		hPlot = subplot(2, 2, 2);
%       hold on; cet option met tous les traits à chaque point
 		grid on;
        timestamp(frame) = frame*(1/frame_rate);
        plot(timestamp, meanGrayLevels);
        ylabel('Val. moy niv. gris')
        xlabel('Temps(sec)')		
		title('Signal original', 'FontSize', fontSize);
	
        %NETTOYAGE DU SIGNAL avec transformation de FOURIER + Filtre Passe bas
        [con] = filtered_breath_signal(timestamp, meanGrayLevels, order); 
        plot_PSD(meanGrayLevels); %essayer d'ajouter frame et timestamp comme input
    end
%Compteur du nombre de cycles respiratoires (Méthode alternative pour détecter des anomalies respiratoires)

br_cyc = nb_cycles_respiration(con, order, duration0);

catch ME
	% Partie réservée en cas d'erreur dans l'extraction du fichier vidéo.
	strErrorMessage = sprintf('Erreur lors de l''extraction du fichier. \n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
	uiwait(msgbox(strErrorMessage));
end