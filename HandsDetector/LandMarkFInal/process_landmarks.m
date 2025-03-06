function [valuesxyz, score, type] = process_landmarks(imgs)
    persistent netL;

    if isempty(netL)
        netL = importNetworkFromONNX('models/hand_landmark_sparse_Nx3x224x224.onnx');
    end

    num_images = length(imgs);
    valuesxyz = cell(num_images, 1);
    score = cell(num_images, 1);
    type  = cell(num_images, 1);

    for i = 1:num_images
        img = imgs{i}; 
        [xyz, score_i, leftorRigh]= predict(netL,img);
    
        valuesxyz{i} = xyz;
        score{i} = score_i;
        type{i}= leftorRigh; 
    end
end