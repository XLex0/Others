function [originalImage, imageInput] = pre_process_palm(frame)
    % Cargar la imagen desde la ruta proporcionada
    
     originalImage= frame;

    % Redimensionar manteniendo la proporción
    imageResized = imresize(originalImage, [192, 192]);

    % Normalizar la imagen
    imageNormalized = double(imageResized) / 255;

    % Convertir a formato esperado
    imageInput = single(imageNormalized);
end