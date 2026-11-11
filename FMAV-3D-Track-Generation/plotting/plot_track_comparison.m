function plot_track_comparison(track)
% PLOT_TRACK_COMPARISON
% Compares the MATLAB-generated track with the Onshape sampling.

figure;
plot3(track.x, track.y, track.z, 'LineWidth', 2);

axis equal;
grid on;
hold on;

plot3(track.x_onshape, track.y_onshape, track.z_onshape, 'LineWidth', 2);

xlabel('X Position (m)');
ylabel('Y Position (m)');
zlabel('Z Position (m)');

title('3D Track Comparison');
legend('MATLAB Generated', 'Onshape Sampling', ...
    'Location', 'best');

end