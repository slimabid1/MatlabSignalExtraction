function [cropped_vid] = crop_video(folder, vid_name, ext)

%Setup du chemin de la video entrée en paramètres
path_vid = strcat(folder,'/',vid_name,ext);

%Setup du nom (path) de la nouvelle video rognée (avec 9 fps comme dans papier/fréquence de capture de la caméra FLIROne)
cropped_vid = strcat(folder,'/','Cropped_',vid_name);
vid1 = VideoReader(path_vid);

%Partie resérvée pour rogner la vidéo aux dimensions (x, y, largeur, hauteur)
n = vid1.NumberOfFrames;
writerObj1 = VideoWriter(cropped_vid,'MPEG-4');
writerObj1.FrameRate = 9;
open(writerObj1);
for i=1 : n
  im=read(vid1,i);
  %imc=imcrop(im,[390 700 250 250]);% Dimension de la vidéo rognée (statique pour l'instant) ==> insertion alternative dynamique Nose Tracking)
  %imc=imcrop(im,[300 600 300 300]);
  %imc=imcrop(im,[250 650 300 300]); %pour 1.mp4
  imc=imcrop(im,[230 670 240 280]);
  img=rgb2gray(im);
   [a,b]=size(img);
   imc=imresize(imc,[a,b]);
   writeVideo(writerObj1,imc);  
end 
cropped_vid = strcat(cropped_vid,'.mp4');
close(writerObj1);