function plot_theta_mapping(theta)
% PLOT_THETA_MAPPING
% Plots the linear and nonlinear wing twist mappings.

%% 2D Theta Mapping

figure;
plot(theta.x_linear, theta.y_linear, 'LineWidth', 2);
hold on;

xlabel('x');
ylabel('y');

axis equal;
grid on;

plot(theta.x_nonlinear, theta.y_nonlinear, '--', 'LineWidth', 2);

title('Comparing Linear and Nonlinear Theta Mapping');
legend('Linear', 'Nonlinear', ...
    'Location', 'best');


end