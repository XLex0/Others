% Configurar la cámara usando webcam
cam = webcam;  % Usa la cámara predeterminada del sistema



while true
    % Captura una imagen de la cámara
    frame = snapshot(cam);

   
    % Procesar la imagen
    [image, imageInput] = pre_process_palm(frame);

    % Obtener las posibles cajas (boxes) de la detección
    boxes = process_palm(imageInput);
    clear imageInput;
    % Obtener los centros de los puntos clave
    hands = post_process_palm(image, boxes);

    if ~isempty(hands)
     [image, coord, cut]= draw_palm(image,hands);

        if ~isempty(cut)
            [cut_processed,sizes]=pre_process_landmark(cut);
            [xyz, score, type]= process_landmarks(cut_processed);

            [cut, xyz, coord, type]=post_process_landmark(cut, xyz, score, type, coord);

            finimg = draw_landmark(image,cut, xyz, coord);

            clear imageInput boxes frame hands cut_processed cut score;
         else
            finimg=frame;
        end
     else
            finimg=frame;
    end
    imshow(finimg);

    key = get(gcf, 'CurrentKey'); % Obtener la tecla presionada
    if strcmp(key, 'escape') % Si la tecla es ESC
          clear cam; % Limpiar la cámara
          break; % Salir del bucle
     end
end

