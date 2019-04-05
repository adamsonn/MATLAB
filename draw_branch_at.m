function can_branch = draw_branch_at(x, y, thickness, len, direction)
% check length
if len < min_branch_length
    % add leaf here
    leaf_count = leaf_count + 1;
    leaf_locations(leaf_count, :) = [x y];
    can_branch = false;
    return;
end
% generate branch angles
theta_1 = branch_angle * (1.0 + branch_angle_randomness * max(min(randn(), 1), -1));
theta_2 = -branch_angle * (1.0 + branch_angle_randomness * max(min(randn(), 1), -1));
% we use a unit length complex number to represent the directional
% vector here, and rotation is done via complex number multiplication
new_dir_1 = direction * (cos(theta_1) + 1j*sin(theta_1));
new_dir_2 = direction * (cos(theta_2) + 1j*sin(theta_2));
% compute end locations of the new branches
new_x_1 = x + real(new_dir_1) * len;
new_y_1 = y + imag(new_dir_1) * len;
new_x_2 = x + real(new_dir_2) * len;
new_y_2 = y + imag(new_dir_2) * len;
% when drawing, draw a litte longer to make the junctions look better
extra_x_1 = real(new_dir_1) * thickness;
extra_y_1 = imag(new_dir_1) * thickness;
extra_x_2 = real(new_dir_2) * thickness;
extra_y_2 = imag(new_dir_2) * thickness;
% draw the two branches
line([x new_x_1+extra_x_1], [y new_y_1+extra_y_1], ...
    'LineWidth', thickness, 'Color', branch_color);
line([x new_x_2+extra_x_2], [y new_y_2+extra_y_2], ...
    'LineWidth', thickness, 'Color', branch_color);
% make new branches
decay = branch_decay_factor * (1.0 + branch_decay_randomness * max(min(randn(), 1), -1));
new_length = decay * len;
new_thickness = decay * thickness;
if ~draw_branch_at(new_x_1, new_y_1, new_thickness, new_length, new_dir_1) || ...
   ~draw_branch_at(new_x_2, new_y_2, new_thickness, new_length, new_dir_2)
    % we have already branched here, but cannot further branch
    % add a leaf at the starting location of the current branch
    leaf_count = leaf_count + 1;
    leaf_locations(leaf_count, :) = [x y];
end
can_branch = true;
end