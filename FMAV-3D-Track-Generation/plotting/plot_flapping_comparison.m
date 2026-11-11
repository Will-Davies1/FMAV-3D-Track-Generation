function plot_flapping_comparison(flap)
% PLOT_FLAPPING_COMPARISON
% Compares the MATLAB-generated wing flapping motion with the
% sampled Onshape motion.

%% Plot flapping motion

figure;
hold on;
grid on;
axis equal;

plot(flap.y_onshape, flap.z_onshape, ...
    'k-', 'LineWidth', 2);

plot(flap.y, flap.z, ...
    'r--', 'LineWidth', 2);

xlabel('Y Position (m)');
ylabel('Z Position (m)');

title('Wing Flapping Motion');
legend('Onshape Sampling', 'MATLAB Generated', ...
    'Location', 'best');

end