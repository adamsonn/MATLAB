function draw_leaves(leave_size, leave_size_randomness, alpha, alpha_randomness)
for ii = 1:leaf_count
    % add randomness to size and transparency
    cur_size = leave_size * (1.0 + leave_size_randomness * max(min(randn(), 1), -1));
    cur_alpha = alpha * (1.0 + alpha_randomness * randn());
    cur_alpha = max(min(cur_alpha, 1), 0);
    cur_color = [leaf_color cur_alpha];
    % compute and add variance to the location of the current leaf
    loc = leaf_locations(ii,:) - cur_size/2;
    theta = unifrnd(0, 2*pi);
    offset = unifrnd(0, leaf_offset);
    loc = loc + [cos(theta) sin(theta)] * offset;
    % draw the current leaf
    rect = [loc cur_size cur_size];
    rectangle('Position', rect, 'FaceColor', cur_color, ...
        'EdgeColor', 'none', 'LineWidth', 1, 'Curvature', [1 1]);
end
end