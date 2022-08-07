clear all;
close all;
clc


%________________________________THRESHOLDING____________________________


%I = im2single(imread( 'sunflowers.jpg' ));
%threshold = 0.00008; %sunflower

%I = im2single(imread( 'fishes.jpg' ));
%threshold = 0.0000000%5; %fishes
 
%I = im2single(imread( 'green_leaf_leaves.jpg' ));
%I=imresize(I,0.5,'bilinear');
%threshold = 0.000005; %leaf

%I = im2single(imread( 'fylla1.jpg' ));
%I=imresize(I,0.1,'bilinear'); 
%threshold = 0.00007; %fylla1


%I = im2single(imread( 'building.jpg' ));
%threshold =  0.00005; %building


I = im2single(imread( 'japan_building.jpg' ));
I=imresize(I,0.5,'bilinear'); 
threshold = 0.00005; %japan_building 

%I = im2single(imread( 'japan_building1.jpg' ));
%I=imresize(I,0.5,'bilinear'); 
%threshold = 0.00007; %japan_building1




%I=imresize(I,0.1,'bilinear'); %for big images like fylla 
%I=imresize(I,0.5,'bilinear'); %for big images like japan_building,green_leaf
 
 figure;
 imshow(I);
 
% Ig=rgb2gray(I);
% Igd=im2double(Ig);
 Igd=im2double(I(:,:,1));
 figure;
 imshow(Igd);

 %s=1.8 or 2
 H = fspecial('gaussian',[40 40],1.6);
 g = fspecial('gaussian',[15 15],1.6);
 [h,w]=size(Igd);
 n=6% six images in each octave

 scale_space=cell(n,1);

 Ig=imfilter(Igd, H, 'replicate','same','conv');
 scale_space{1}=Ig;
 figure;
 imshow(scale_space{1}+0.5);%firt filtered image
 %___________________________APROACH2__________________________________________
  jmax=6;
 k=1.2;%% square root of 2
 [x,y]=size(Ig);
 sigma=1.6;
 kfinal=1;
 tic
 for i=0:2
 kfinal=kfinal*sigma%^(i+1);
     
     for j=1:jmax
         temp=imresize(scale_space{i*(jmax)+1},1/kfinal,'bilinear');
         kfinal=kfinal*k;%
         Iblur=imresize(temp,[x,y],'bilinear');
         figure;
         imshow(Iblur+0.5);
         scale_space{(i*(jmax)+j+1)}= Iblur;  

     end
 end
 toc
 
  DOG_space=cell(15,1);
 jmax=5;
for i=0:2
    for j=1:jmax
        DOG_space{(i*jmax)+j}=scale_space{(i*(jmax+1)+j+1)}-scale_space{(i*(jmax+1)+j)};
        figure;
        imshow(DOG_space{(i*jmax)+j}+0.5);
    end 
end
 %______________________________APROACH 1__________________________________
 tic
 jmax=6;%% jmax +1 the number of applying the gaussian filter
 k=1.41;%% square root of 2
 sigma=1.6;%
 kfinal=sigma;
 for i=0:2 %% 3 octaves
     kfinal=sigma^(i+1);
     
     for j=1:jmax
         H = fspecial('gaussian',[40,40],kfinal);
         kfinal=kfinal*k;%

         Iblur=imfilter(scale_space{(i*(jmax)+1)}, H, 'replicate','same','conv');
         
         figure;
         imshow(Iblur+0.5);
         scale_space{(i*(jmax)+j+1)}= Iblur;  

     end
 end
 toc
%__________________DOG SPACE CREATION____________________________________
 DOG_space=cell(15,1);
 jmax=5;
for i=0:2
    for j=1:jmax
        DOG_space{(i*jmax)+j}=scale_space{(i*(jmax+1)+j+1)}-scale_space{(i*(jmax+1)+j)};
        figure;
       imshow(DOG_space{(i*jmax)+j}+0.5);
    end 
end

 
%_________________EXTREMA DETECTION__________________________________
output=ExtremaDetector(DOG_space, jmax);
[length,j]=size(output);
output_concat=[0 0 0];

for i=1:length
    [output_length,y]=size(output{i});
    radius=i.*ones(output_length,1);
    current_output=[output{i} radius];
    output_concat=vertcat(output_concat,current_output);
    
end
figure;
show_all_circles(I, output_concat(:,2), output_concat(:,1), output_concat(:,3)*2)

output_final = harrisDetection (Igd, threshold,g,output_concat);%filtering keypoints
figure;
show_all_circles(I, output_final(:,2), output_final(:,1), output_final(:,3)*2)
