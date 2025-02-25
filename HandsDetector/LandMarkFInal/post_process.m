function [centers1, centers2] = post_process(boxes, image_height, image_width)
    % Parámetros de configuración
    score_threshold = 0.60;

    keep = boxes(:, 1) > score_threshold;
    boxes = boxes(keep, :);

    % Inicializar listas para almacenar las coordenadas
    centers1 = [];
    centers2 = [];

    % Verificar si no hay detecciones
    if isempty(boxes)
        centers1 = [-1, -1];  % Valores negativos si no hay detección
        centers2 = [-1, -1];  % Valores negativos si no hay detección
        return;
    end

    % Procesar cada detección
    for i = 1:size(boxes, 1)
        % Extraer los valores de los puntos clave
        box_x = boxes(i, 2);
        box_y = boxes(i, 3);
        box_size = boxes(i, 4);
        kp0_x = boxes(i, 5);
        kp0_y = boxes(i, 6);
        kp2_x = boxes(i, 7);
        kp2_y = boxes(i, 8);

        if box_size > 0
            % Calcular las coordenadas originales de los puntos clave
            center1 = [kp0_x * image_width, kp0_y * image_height]; 
            center2 = [kp2_x * image_width, kp2_y * image_height]; 

            % Añadir las coordenadas a las listas
            centers1 = [centers1; center1]; 
            centers2 = [centers2; center2]; 
        end
    end
end
