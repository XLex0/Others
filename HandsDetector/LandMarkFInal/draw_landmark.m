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
        cap_width = row(6);
        cap_height = row(7);

        % Matriz de rotación
        theta = deg2rad(degree);  % Convertir a radianes
        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];  % Matriz de rotación 2D

        % Escalar todas las coordenadas (X, Y) en una sola operación
        temp(:, 1) = temp(:, 1) * cap_width + row(1);  % Escalar las coordenadas X
        temp(:, 2) = temp(:, 2) * cap_height + row(2);  % Escalar las coordenadas Y

        % Aplicar la rotación a todas las coordenadas X, Y
        rotated_coords = (R * (temp(:, 1:2) - [cx, cy])' + [cx; cy])'; 

        % Dibujar las líneas (Polígono)
        original = draw_lines(original, rotated_coords);

        % Dibujar los puntos
        for j = 1:21
            rotated_x = rotated_coords(j, 1);
            rotated_y = rotated_coords(j, 2);
            original = insertShape(original, 'FilledCircle', [rotated_x, rotated_y, 8], 'Color', 'green', 'Opacity', 1);
        end
    end

    % Devolver la imagen final
    image = original;
end

function image = draw_lines(original, coords)

    % Conexiones para los puntos de la palma (polígono)
    connections1 = [1, 2, 3, 6, 10, 14, 18, 1];  % Puntos de la palma en polígono
    connections2 = [3, 4, 5];  % Pulgar
    connections3 = [6, 7, 8, 9];  % Índice
    connections4 = [10, 11, 12, 13];  % Medio
    connections5 = [14, 15, 16, 17];  % Anular
    connections6 = [18, 19, 20, 21];  % Meñique

    % Seleccionamos las coordenadas de cada conjunto de conexiones
    selected_points1 = coords(connections1, :);  % Palma
    selected_points2 = coords(connections2, :);  % Pulgar
    selected_points3 = coords(connections3, :);  % Índice
    selected_points4 = coords(connections4, :);  % Medio
    selected_points5 = coords(connections5, :);  % Anular
    selected_points6 = coords(connections6, :);  % Meñique

    % Dibujar el polígono de la palma
    polygon_points = reshape(selected_points1', 1, []);  % Palma
    original = insertShape(original, 'Polygon', polygon_points, 'Color', 'red', 'LineWidth', 6);
    
    % Definir un conjunto de conexiones para los 4 dedos (excluyendo el pulgar)
    all_fingers = {selected_points2, selected_points3, selected_points4, selected_points5, selected_points6};
    
    % Dibujar líneas para cada dedo (pulgar, índice, medio, anular, meñique)
    for k = 1:length(all_fingers)
        % Obtener los puntos del dedo
        selected_points = all_fingers{k};
        
        % Dibujar las líneas del dedo
        for j = 1:length(selected_points) - 1
            x1 = selected_points(j, 1);
            y1 = selected_points(j, 2);
            x2 = selected_points(j + 1, 1);
            y2 = selected_points(j + 1, 2);
            original = insertShape(original, 'Line', [x1, y1, x2, y2], 'Color', 'blue', 'LineWidth', 6);
        end
    end

    % Devolver la imagen con las líneas dibujadas
    image = original;
end
