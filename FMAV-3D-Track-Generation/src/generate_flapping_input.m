function flap = generate_flapping_input(data_folder)
% GENERATE_FLAPPING_INPUT
% Generates the FMAV wing flapping kinematics using the crank-linkage
% geometry and compares the resulting coordinates with Onshape data.
%
% INPUT:
%   data_folder - Directory containing normal_stroke.xlsx
%
% OUTPUT:
%   flap - Structure containing:
%       .x, .y, .z       MATLAB wing coordinates
%       .phi             Wing rotation angle [rad]
%       .theta           Crank rotation angle [rad]
%       .y_onshape       Onshape Y coordinates
%       .z_onshape       Onshape Z coordinates

%% 1. Read Onshape Flapping Data

on_flapdata = readmatrix(fullfile(data_folder, ...
                                  'normal_stroke.xlsx'));

flap.y_onshape = on_flapdata(:,3) * 1e-3;
flap.z_onshape = on_flapdata(:,1) * -1e-3;


%% 2. Define Linkage Geometry

% Linkage measurements
z_p = -0.25e-3;
y_p = 11.92e-3;

r_c = 2e-3;
r_p = 4.5e-3;
l = 12e-3;

% Wing span
l_span = 30e-3;


%% 3. Generate Crank Rotation

omega = 2*pi*1;
theta_0 = 0;

t = linspace(0, 1, 200);
theta = theta_0 + omega*t;

wing_gamma = zeros(1, length(theta));


%% 4. Solve Linkage Position

% Solve the linkage constraint at each time step
for i = 1:length(theta)

    func = @(wing_gamma) ...
        (r_c*cos(theta(i)) - z_p - r_p*cos(wing_gamma))^2 + ...
        (r_c*sin(theta(i)) - y_p - r_p*sin(wing_gamma))^2 - l^2;

    % Use previous solution as the next initial guess
    if i == 1
        guess = 0;
    else
        guess = wing_gamma(i-1);
    end

    wing_gamma(i) = fzero(func, guess);

end


%% 5. Calculate Wing Coordinates

% Wing rotation
phi = -wing_gamma;

% Wing tip coordinates
y_wing = l_span*sin(phi);
z_wing = l_span*cos(phi);
x_wing = zeros(1, length(y_wing));


%% 6. Shift Start to Beginning of Downstroke

[~, idx] = max(y_wing);

y_wing = [y_wing(idx:end), y_wing(1:idx-1)];
z_wing = [z_wing(idx:end), z_wing(1:idx-1)];
phi = [phi(idx:end), phi(1:idx-1)];
x_wing = [x_wing(idx:end), x_wing(1:idx-1)];


%% 7. Align Onshape and MATLAB Coordinates

% Match starting coordinates
matlab_start = [y_wing(1), z_wing(1)];
onshape_start = [flap.y_onshape(1), flap.z_onshape(1)];

% Calculate coordinate offset
offset = matlab_start - onshape_start;

% Apply offset to Onshape data
flap.y_onshape = flap.y_onshape + offset(1);
flap.z_onshape = flap.z_onshape + offset(2);


%% 8. Store MATLAB Results

flap.x = x_wing;
flap.y = y_wing;
flap.z = z_wing;

flap.phi = phi;
flap.theta = theta;

end