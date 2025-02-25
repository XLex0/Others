function [output] = process_palm(img)
    persistent net;
    
    if isempty(net)
        net = importNetworkFromONNX('models/palm_detection_full_inf_post_192x192.onnx');
    end
    
    output= predict(net,img);
end