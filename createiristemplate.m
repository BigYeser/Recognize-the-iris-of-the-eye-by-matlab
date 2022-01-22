
function [template, mask] = createiristemplate(filename)

% path for writing diagnostic images
global DIAGPATH
DIAGPATH = 'diagnostics';

%normalisation parameters
radial_res = 20;
angular_res = 240;
% with these settings a 9600 bit iris template is
% created

%feature encoding parameters
nscales=1;
minWaveLength=18;
mult=1; % not applicable if using nscales = 1
sigmaOnf=0.5;

eyeimage = imread(filename) ;

savefile = [filename,'-houghpara.mat'];
[stat,mess]=fileattrib(savefile);

if stat == 1
    % if this file has been processed before
    % then load the circle parameters and
    % noise information for that file.
    load(savefile);
    
else
    
    % if this file has not been processed before
    % then perform automatic segmentation and
    % save the results to a file
    
    [circleiris circlepupil imagewithnoise] = segmentiris(eyeimage);
    save(savefile,'circleiris','circlepupil','imagewithnoise');
    
end

% WRITE NOISE IMAGE
%

imagewithnoise2 = uint8(imagewithnoise);
imagewithcircles = uint8(eyeimage);

%get pixel coords for circle around iris
[x,y] = circlecoords([circleiris(2),circleiris(1)],circleiris(3),size(eyeimage));
ind2 = sub2ind(size(eyeimage),double(y),double(x)); 

%get pixel coords for circle around pupil
[xp,yp] = circlecoords([circlepupil(2),circlepupil(1)],circlepupil(3),size(eyeimage));
ind1 = sub2ind(size(eyeimage),double(yp),double(xp));


% Write noise regions
imagewithnoise2(ind2) = 255;
imagewithnoise2(ind1) = 255;
% Write circles overlayed
imagewithcircles(ind2) = 255;
imagewithcircles(ind1) = 255;
w = cd;
cd();
imwrite(imagewithnoise2,[filename,'-noise.jpg'],'jpg');
imwrite(imagewithcircles,[filename,'-segmented.jpg'],'jpg');
cd(w);

% perform normalisation

[polar_array noise_array] = normaliseiris(imagewithnoise, circleiris(2),...
    circleiris(1), circleiris(3), circlepupil(2), circlepupil(1), circlepupil(3),filename, radial_res, angular_res);


% WRITE NORMALISED PATTERN, AND NOISE PATTERN
w = cd;
cd();
imwrite(polar_array,[filename,'-polar.jpg'],'jpg');
imwrite(noise_array,[filename,'-polarnoise.jpg'],'jpg');
cd(w);

% perform feature encoding
[template mask] = encode(polar_array, noise_array, nscales, minWaveLength, mult, sigmaOnf); 