function image = draw_landmark(original, cut, xyz, coord)
    % Número de imágenes
    num_images = numel(cut);
    
    % Recorremos cada imagen
    for i = 1:num_images
        % Extraemos el conjunto de landmarks para la imagen i
        temp = xyz{i};  % Esto es una matriz 21x3 de coordenadas de los landmarks
        [cap_height, cap_width, ~] = size(cut{i});  % Dimensiones de la imagen
        
        % Coordenadas de referencia (cx, cy) para la rotación
        row = coord(i, :); % Esto es una fila de 2x5, toma las coordenadas de la fila actual
        cx = row(3);  % Punto de rotación X
        cy = row(4);  % Punto de rotación Y
        degree = row(5);  % Ángulo de rotación en grados
        cap_width =row(6);
        cap_height =row(7);
        % Matriz de rotación
        theta = deg2rad(degree);  % Convertir a radianes
        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];  % Matriz de rotación 2D
    
        for j = 1:21
            % Coordenadas (x, y) para cada landmark, escalados a las dimensiones de la imagen
            landmark_x = temp(j, 1) * cap_width + row(1);  % Coordenada X escalada
            landmark_y = temp(j, 2) * cap_height + row(2);  % Coordenada Y escalada

            % Aplicamos la rotación a las coordenadas
            rotated_coords = R * [landmark_x - cx; landmark_y - cy] + [cx; cy];
            
            % Las coordenadas rotadas
            rotated_x = rotated_coords(1);
            rotated_y = rotated_coords(2);
            
            % Dibuja el punto rotado en la imagen utilizando un marcador
            original = insertMarker(original, [rotated_x, rotated_y], 'color', 'red', 'size', 10);
        end
    end

    % Devolver las imágenes con los puntos dibujados
    image = original;
end
