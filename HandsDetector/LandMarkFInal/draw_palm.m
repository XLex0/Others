function [image, coords, cut] = draw_palm(img, hands)
    % Obtener el tamaño de la imagen
    [cap_height, cap_width, ~] = size(img);
    wh_ratio = cap_width / cap_height;

    coords = [];
    cut = {};
    
    for i = 1:size(hands, 1)
        sqn_rr_size = hands(i, 1);
        rotation = hands(i, 2);
        sqn_rr_center_x = hands(i, 3);
        sqn_rr_center_y = hands(i, 4);

        % Calcular las coordenadas del rectángulo
        cx = round(sqn_rr_center_x * cap_width);
        cy = round(sqn_rr_center_y * cap_height);
        xmin = round((sqn_rr_center_x - (sqn_rr_size / 2.8)) * cap_width);
        xmax = round((sqn_rr_center_x + (sqn_rr_size / 2.8)) * cap_width);
        ymin = round((sqn_rr_center_y - (sqn_rr_size * wh_ratio / 2.3)) * cap_height);
        ymax = round((sqn_rr_center_y + (sqn_rr_size * wh_ratio / 2.3)) * cap_height);

        % Asegurar que las coordenadas estén dentro de la imagen
        xmin = max(1, xmin);
        xmax = min(cap_width, xmax);
        ymin = max(1, ymin);
        ymax = min(cap_height, ymax);

        degree = rad2deg(rotation); % Convertir radianes a grados


        width = xmax - xmin;
        height = ymax - ymin;
        % Calcular las coordenadas de las esquinas antes de la rotación
        x1 = cx - width / 2;  y1 = cy - height / 2;
        x2 = cx + width / 2;  y2 = cy - height / 2;
        x3 = cx + width / 2;  y3 = cy + height / 2;
        x4 = cx - width / 2;  y4 = cy + height / 2;
        
        % Matriz de rotación
        theta = deg2rad(degree); % Convertir a radianes
        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    
        % Rotar cada esquina alrededor de (cx, cy)
        p1 = R * [x1 - cx; y1 - cy] + [cx; cy];
        p2 = R * [x2 - cx; y2 - cy] + [cx; cy];
        p3 = R * [x3 - cx; y3 - cy] + [cx; cy];
        p4 = R * [x4 - cx; y4 - cy] + [cx; cy];
    
        % Dibujar el rectángulo como un polígono
        polygon_coords = [p1(1), p1(2), p2(1), p2(2), p3(1), p3(2), p4(1), p4(2)];
        %img = insertShape(img, 'polygon', polygon_coords, 'Color', 'red', 'LineWidth', 2);

        coords = [coords; x1, y1, cx, cy, degree, width, height];
        rec = cut_img(img, polygon_coords,degree); 
        cut{end+1} = rec;
    end
    
    % Devolver la imagen con los rectángulos dibujados
    image = img;
end

function cropped_img = cut_img(img_orig, polygon_coords, degree)
    % Extraer las coordenadas de los vértices
    x = polygon_coords(1:2:end); % Coordenadas X
    y = polygon_coords(2:2:end); % Coordenadas Y
    
    % Asegurarse de que las coordenadas sean de tipo double
    x = double(x);
    y = double(y);
    
    % Crear una máscara con la forma del polígono usando poly2mask
    BW = poly2mask(x, y, size(img_orig, 1), size(img_orig, 2));

    % Crear una imagen con el área de la máscara
    masked_img = img_orig .* uint8(repmat(BW, [1, 1, 3])); % Aplicar la máscara a cada canal RGB
    
    % Extraer la región de interés utilizando el polígono
    % Obtener las coordenadas del rectángulo que rodea el polígono
    stats = regionprops(BW, 'BoundingBox'); 
    bounding_box = stats.BoundingBox;
    
    % Recortar la imagen dentro del rectángulo que rodea el polígono
    cropped_img = imcrop(masked_img, bounding_box);
    cropped_img = imrotate(cropped_img, degree, 'bilinear', 'crop'); 

    
    width = bounding_box(3);  % El ancho del rectángulo
    height = bounding_box(4); % altura rectangulo

    % Convertir la imagen a escala de grises para detectar áreas negras
    gray_img = rgb2gray(cropped_img);
    
    % Umbralizar para detectar los píxeles que no son negros (con un umbral de 1)
    non_black_mask = gray_img > 1;  % Píxeles con valor mayor a 1 (no negros)
    
    % Encontrar el recuadro de la imagen sin los bordes negros
    [rows, cols] = find(non_black_mask);  % Índices de los píxeles no negros
    
    % Obtener el límite de la imagen recortada (sin los bordes negros)
    row_min = min(rows);
    row_max = max(rows);
    col_min = min(cols);
    col_max = max(cols);
    
    % Recortar la imagen sin los bordes negros y ajustar
    cropped_img = cropped_img(row_min:row_max, col_min:col_max, :);
    cropped_img = imresize(cropped_img, [height, width]);
end
