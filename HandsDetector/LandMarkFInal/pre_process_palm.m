function [originalImage, imageInput, image_height, image_width] = pre_process_palm(originalImage)
    % Cargar la imagen desde la ruta proporcionada
    

    % Obtener las dimensiones de la imagen original
    image_height = size(originalImage, 1);
    image_width = size(originalImage, 2);

    % Redimensionar manteniendo la proporción
    imageResized = imresize(originalImage, [192, 192]);

    % Normalizar la imagen
    imageNormalized = double(imageResized) / 255;

    % Convertir a formato esperado
    imageInput = single(imageNormalized);
end