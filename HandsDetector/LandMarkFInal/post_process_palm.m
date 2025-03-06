function hands = post_process(image, boxes)
    score_threshold=0.8;
    % Obtener dimensiones de la imagen
    image_height = size(image, 1);
    image_width = size(image, 2);
    
    % Definir square_standard_size y square_padding_half_size
    square_standard_size = max(image_height, image_width);
    square_padding_half_size = abs(image_height - image_width);
    
    % Filtrar boxes por score_threshold
    keep = boxes(:, 1) > score_threshold;
    boxes = boxes(keep, :);
    
    hands = [];

    for i = 1:size(boxes, 1)

        box_x = boxes(i, 2);
        box_y = boxes(i, 3);
        box_size = boxes(i, 4);
        kp0_x = boxes(i, 5);
        kp0_y = boxes(i, 6);
        kp2_x = boxes(i, 7);
        kp2_y = boxes(i, 8);
        
        if box_size > 0
            kp02_x = kp2_x - kp0_x;
            kp02_y = kp2_y - kp0_y;
            sqn_rr_size = 2.0 * box_size;
            rotation = 0.5 * pi - atan2(-kp02_y, kp02_x);
            
            % Normalizar rotación si es necesario
            rotation = normalize_radians(rotation);  
            
            sqn_rr_center_x = box_x + 0.5 * box_size * sin(rotation);
            sqn_rr_center_y = box_y - 0.5 * box_size * cos(rotation);
            %sqn_rr_center_y = (sqn_rr_center_y * square_standard_size - square_padding_half_size) / image_height;
            
            % Agregar resultado a la lista
            hands = [hands; [sqn_rr_size, rotation, sqn_rr_center_x, sqn_rr_center_y]];
        end
    end
end


function normalized_angle = normalize_radians(angle)
    % Normaliza el ángulo en radianes al rango [-pi, pi]
    normalized_angle = angle - 2 * pi * floor((angle + pi) / (2 * pi));
end
