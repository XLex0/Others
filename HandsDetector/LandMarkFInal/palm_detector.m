    frame = imread("image/test3.jpg");

    % Procesar la imagen
    [image, imageInput] = pre_process_palm(frame);

    % Obtener las posibles cajas (boxes) de la detección
    boxes = process_palm(imageInput);

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
        end
    end

    imshow(finimg);




  
