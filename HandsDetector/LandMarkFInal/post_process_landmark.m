function [cutF, xyzF, coordF, typeF] = post_process_landmark(cut, xyz, score, type, coord)
    score_threshold = 0.3;

    num_images = length(cut);

    xyzF = {};
    typeF = {};  % Lista vacía para xyz filtrado
    cutF = [];  % Array vacío para cut filtrado
    coordF =[];  % Inicializamos coordF como un array single vacío

    for i = 1:num_images
        if score{i} > score_threshold  % Verifica si el score es mayor al umbral
            xyzT=xyz{i}/224;
            xyzF{end+1} = reshape(xyzT, [3, 21])';
                

            typeF{end+1} = type{i};
            cutF = [cutF; cut(i)];

            coordF = [coordF; coord(i, :)];  % Concatenamos la columna de coord
        end 

    end

end
