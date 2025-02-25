
img = imread('image/test5.jpg');
[image, imageInput, image_height, image_width] = pre_process_palm(img);

% lista de posibles cajas:
% forma: score, box_x, box_y, box_size, kp0X, kp0Y, kp2X, kp2Y
boxes = process_palm(imageInput);

[center0, center2]=post_process(boxes,image_height, image_width);



image = insertShape(image, 'FilledCircle', [center0, 5], 'Color', 'red', 'LineWidth', 2);

image = insertShape(image, 'FilledCircle', [center2, 5], 'Color', 'blue', 'LineWidth', 2);


% Mostrar la imagen con las detecciones
imshow(image);
