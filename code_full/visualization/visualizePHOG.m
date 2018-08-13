function im = visualizePHOG(w)
% Visualize positive HOG features/weights.

% make pictures of positive weights
bs = 20;
w = w(:,:,1:9);
scale = max(w(:));
pos = HOGpicture(w, bs) * 255/scale;
im = uint8(pos);

imagesc(im); 
colormap gray;
axis equal;
axis off;
drawnow;
