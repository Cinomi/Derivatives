function gussian_filt = DtG(pattern, kernel_length, sigma)
    % 0th order: G0
    X = [1:kernel_length]-kernel_length/2;
    gauss_x = 1/(sqrt(2*pi)*sigma)*exp(-0.5*X.^2/(sigma^2));
    gauss_y = gauss_x';
    
    G0 = gauss_y * gauss_x;
    G0 = G0./(max(G0(:)));
    
    if pattern==0
        gussian_filt = G0;
    end
    
    % 1st order: G1
    grad_x = [1,-1];
    G1_x = conv2(G0, grad_x, 'same');
    
    grad_y = [-1,1]';
    G1_y = conv2(G0, grad_y, 'same');
    
    if pattern==1
        gussian_filt(:,:,1) = G1_x;
        gussian_filt(:,:,2) = G1_y;
    end
    
    % 2nd order: G2
    grad_w1 = [0,-1; 
               1,0];
    %G2_w1 = conv2(G1_y, grad_w1, 'valid');
    G2_xx = conv2(G1_x,grad_x,'same');
    
    grad_w2 = [1,-1];
    G2_w2 = conv2(G1_x, grad_w2, 'valid');
    G2_w2(end,:)=[];
    G2_xy = conv2(G1_x,grad_y,'same');
    
    grad_w3 = [1,0;
               0,-1];
    G2_w3 = conv2(G1_x, grad_w3, 'valid');
    G2_yy = conv2(G1_y,grad_y,'same');
    if pattern==2
        gussian_filt(:,:,1) = G2_xx;
        gussian_filt(:,:,2) = G2_xy;
        gussian_filt(:,:,3) = G2_yy;
    end
end