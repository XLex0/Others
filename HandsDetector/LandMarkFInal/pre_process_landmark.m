function [img_adapted_list, original_sizes] = pre_process_landmark(cut)
    img_adapted_list = {};  % Para almacenar las imágenes procesadas
    original_sizes = [];    % Para almacenar las dimensiones originales de cada imagen
    
    for i = 1:length(cut)
        img = cut{i};  % Obtener cada recorte
        
        % Obtener el tamaño de la imagen original
        [img_height, img_width, num_channels] = size(img);
    
        % Redimensionar la imagen a 224x224
        imageResized = imresize(img, [224, 224]);  % Redimensionar a 224x224
         imageNormalized = double(imageResized) / 255;

         % Convertir a formato esperado
        img_adapted = single(imageNormalized);
        % Almacenar las dimensiones originales de la imagen
        original_size = [img_height, img_width];  % Guardar las dimensiones originales
    

        % Almacenar la imagen procesada y las dimensiones originales
        img_adapted_list{end+1} = img_adapted;  % Almacenar la imagen procesada
        original_sizes = [original_sizes; original_size];  % Almacenar el tamaño original
    end
end
