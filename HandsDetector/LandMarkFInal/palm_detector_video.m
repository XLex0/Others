% Configurar la cámara usando webcam
cam = webcam;  % Usa la cámara predeterminada del sistema



while true
    % Captura una imagen de la cámara
    frame = snapshot(cam);

    % Procesar la imagen
    [image, imageInput, image_height, image_width] = pre_process_palm(frame);

    % Obtener las posibles cajas (boxes) de la detección
    boxes = process_palm(imageInput);

    % Obtener los centros de los puntos clave
[centers1, centers2] = post_process(boxes, image_height, image_width);

    for i = 1:size(centers1, 1)
        center0 = centers1(i, :);  % Centro de kp0
        center2 = centers2(i, :);  % Centro de kp2

        % Dibujar los puntos clave
        image = insertShape(image, 'FilledCircle', [center0, 5], 'Color', 'red', 'LineWidth', 2);
        image = insertShape(image, 'FilledCircle', [center2, 5], 'Color', 'blue', 'LineWidth', 2);
    end
    % Mostrar la imagen procesada
    imshow(image);

    % Detener el ciclo si se presiona una tecla (puedes agregar un condicional para detener)
    if ~ishandle(imshow(image))
        clear cam;
        break;
        
    end
end

% Detener la cámara y liberar recursos
clear cam;
