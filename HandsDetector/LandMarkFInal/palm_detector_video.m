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
    hands = post_process(image, boxes);

    if ~isempty(hands)
         image= draw_palm(image,hands);
    end
    imshow(image);

    key = get(gcf, 'CurrentKey'); % Obtener la tecla presionada
    if strcmp(key, 'escape') % Si la tecla es ESC
          clear cam; % Limpiar la cámara
          break; % Salir del bucle
     end
end

