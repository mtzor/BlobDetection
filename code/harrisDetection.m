function output = harrisDetection (image, threshold,g,extremaMat)
          corners = [];
        ie=1;
        % derivatives in x and y direction
        [dx,dy] = meshgrid(-1:1 , -1:1);
        Ix = conv2(double(image),dx,'same');
        Iy = conv2(double(image),dy,'same');

        % Calculate entries of the M matrix
        Ix2 = conv2(double(Ix.^2) , g, 'same');
        Iy2 = conv2(double(Iy.^2) , g, 'same');
        Ixy = conv2(double(Ix.*Iy), g, 'same');

        % Harris measure
        % R = (Ix2.*Iy2 - Ixy.^2) ./ (Ix2 + Iy2 + eps);%Szelinki
        R = (Ix2.*Iy2 - Ixy.^2) -0.15*(Ix2 + Iy2 + eps).^2 ;%Harris
        % imit the number of extrima
        [exi,exj] = size(extremaMat);
        for i=1:exi
            
            cx = extremaMat(i,1);
            cy = extremaMat(i,2);
            if(cx~=0 && cy~=0)
                currentR=R(cx,cy);
                if(currentR > threshold)
                    corners(ie,1)=cx;
                    corners(ie,2)=cy;
                    corners(ie,3)=extremaMat(i,3);
                    ie=ie+1;
                end
            end
        end
output = corners;
