function [ H ] = computeHomography( x_fixed, y_fixed, x_moving, y_moving )
h = zeros(8,1);
A = [-x_fixed(1) -y_fixed(1) -1 0 0 0 x_fixed(1)*x_moving(1) y_fixed(1)*x_moving(1) x_moving(1); % h(1);
    0 0 0 -x_fixed(1) -y_fixed(1) -1 x_fixed(1)*y_moving(1) y_fixed(1)*y_moving(1) y_moving(1); % h(2);
    -x_fixed(2) -y_fixed(2) -1 0 0 0 x_fixed(2)*x_moving(2) y_fixed(2)*x_moving(2) x_moving(2); % h(3);
    0 0 0 -x_fixed(2) -y_fixed(2) -1 x_fixed(2)*y_moving(2) y_fixed(2)*y_moving(2) y_moving(2); % h(4);
    -x_fixed(3) -y_fixed(3) -1 0 0 0 x_fixed(3)*x_moving(3) y_fixed(3)*x_moving(3) x_moving(3); % h(5);
    0 0 0 -x_fixed(3) -y_fixed(3) -1 x_fixed(3)*y_moving(3) y_fixed(3)*y_moving(3) y_moving(3); % h(6);
    -x_fixed(4) -y_fixed(4) -1 0 0 0 x_fixed(4)*x_moving(4) y_fixed(4)*x_moving(4) x_moving(4); % h(7);
    0 0 0 -x_fixed(4) -y_fixed(4) -1 x_fixed(4)*y_moving(4) y_fixed(4)*y_moving(4) y_moving(4)]; % h(8)];
[~, ~, V] = svd(A);
H = V(:,9);
H(9) = 1;
H = reshape(H,3,3)';
