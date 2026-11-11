function theta = map_theta(flap)
% MAP_THETA
% Maps the linear angle relationships onto the nonlinear wing flapping
% motion using wing displacement as the interpolation variable.
%
% INPUT:
%   flap - Structure containing wing flapping kinematics
%
% OUTPUT:
%   theta - Structure containing:
%       .angle_deg       Mapped actuator angle [deg]
%       .angle           Mapped actuator angle [rad]
%       .linear_deg      Original linear theta input [deg]
%       .linear          Original linear theta input [rad]
%       .x_linear        Linear arm locus X coordinates
%       .y_linear        Linear arm locus Y coordinates
%       .x_nonlinear     Nonlinear arm locus X coordinates
%       .y_nonlinear     Nonlinear arm locus Y coordinates


%% 1. Split Wing Motion into Downstroke and Upstroke

y_wing_dwn = flap.y(1:100);
y_wing_up = flap.y(101:end);


%% 2. Define Linear Wing Displacement Input

y_lin_dwn = linspace(max(flap.y), min(flap.y), 100);
y_lin_up = linspace(min(flap.y), max(flap.y), 100);

y_input = [y_lin_dwn, y_lin_up];


%% 3. Define Linear Theta Input

% Downstroke
theta1lin = linspace(30, 0, 36);
theta2lin = linspace(0, 0, 64);

% Upstroke
theta3lin = linspace(0, 45, 56);
theta4lin = linspace(45, 45, 25);
theta5lin = linspace(45, 30, 19);

% Combine theta segments
theta_dwn_lin = [theta1lin, theta2lin];
theta_up_lin = [theta3lin, theta4lin, theta5lin];

theta_lin_deg = [theta_dwn_lin, theta_up_lin];
theta_linear = deg2rad(theta_lin_deg);


%% 4. Generate Linear Arm Locus

R_input = 0.02;

x_arm_lin = -R_input*cos(theta_linear);
y_arm_lin = -R_input*sin(theta_linear);

x_track_2Dinput = x_arm_lin;
y_track_2Dinput = y_input + y_arm_lin;


%% 5. Map Theta onto Nonlinear Wing Motion

% Interpolate theta using wing displacement
theta_wing_dwn = interp1(y_lin_dwn, theta_dwn_lin, y_wing_dwn);
theta_wing_up = interp1(y_lin_up, theta_up_lin, y_wing_up);

% Combine downstroke and upstroke
theta_wing_deg = [theta_wing_dwn, theta_wing_up];
theta_wing = deg2rad(theta_wing_deg);


%% 6. Generate Nonlinear Arm Locus

R_wing = 0.02;

x_arm_nonlin = -R_wing*cos(theta_wing);
y_arm_nonlin = -R_wing*sin(theta_wing);

x_track_nonlin = x_arm_nonlin;
y_track_nonlin = flap.y + y_arm_nonlin;


%% 7. Store Results

% Mapped theta
theta.angle_deg = theta_wing_deg;
theta.angle = theta_wing;

% Original linear theta input
theta.linear_deg = theta_lin_deg;
theta.linear = theta_linear;

% Linear arm locus
theta.x_linear = x_track_2Dinput;
theta.y_linear = y_track_2Dinput;

% Nonlinear arm locus
theta.x_nonlinear = x_track_nonlin;
theta.y_nonlinear = y_track_nonlin;

% Linear displacement input
theta.y_input = y_input;

end