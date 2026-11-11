function track = generate_track(flap, theta, data_folder)
% GENERATE_TRACK
% Generates the 3D actuator track by transforming the local
% arm coordinates into the global reference frame.
%
% INPUT:
%   flap        - Structure containing wing flapping kinematics
%   theta       - Structure containing mapped actuator angles
%   data_folder - Directory containing track.xlsx
%
% OUTPUT:
%   track - Structure containing:
%       .x             MATLAB track X coordinates
%       .y             MATLAB track Y coordinates
%       .z             MATLAB track Z coordinates
%       .coords        3D track coordinates [X; Y; Z]
%       .x_onshape     Onshape X coordinates
%       .y_onshape     Onshape Y coordinates
%       .z_onshape     Onshape Z coordinates
%       .coords_onshape Onshape track coordinates


%% 1. Read Onshape Track Data

on_trackdata = readmatrix(fullfile(data_folder, 'track.xlsx'));

x_on_track = on_trackdata(:,2) * -1e-3;
y_on_track = on_trackdata(:,3) * 1e-3;
z_on_track = on_trackdata(:,1) * -1e-3;


%% 2. Define Local Arm Geometry

R_arm = 20e-3;

x_arm_local = -R_arm*cos(theta.angle);
y_arm_local = -R_arm*sin(theta.angle);
z_arm_local = zeros(1, length(theta.angle));

arm_coords_local = [x_arm_local;
                    y_arm_local;
                    z_arm_local];


%% 3. Transform Arm Coordinates into Global Reference Frame

% Preallocate coordinate arrays
wingspan_joint_coords_GLOBAL = zeros(3, length(theta.angle));
arm_coords_GLOBAL = zeros(3, length(theta.angle));

for i = 1:length(theta.angle)

    % Wingspan joint position in global coordinates
    wingspan_joint_coords_GLOBAL(:,i) = ...
        [flap.x(i);
         flap.y(i);
         flap.z(i)];

    % Rotation matrix about global X axis
    R_x = [1,             0,              0;
           0, cos(-flap.phi(i)), -sin(-flap.phi(i));
           0, sin(-flap.phi(i)),  cos(-flap.phi(i))];

    % Transform local arm coordinates into global coordinates
    arm_coords_GLOBAL(:,i) = ...
        wingspan_joint_coords_GLOBAL(:,i) + ...
        R_x * arm_coords_local(:,i);

end


%% 4. Extract MATLAB Track Coordinates

track.x = arm_coords_GLOBAL(1,:);
track.y = arm_coords_GLOBAL(2,:);
track.z = arm_coords_GLOBAL(3,:);

track.coords = arm_coords_GLOBAL;


%% 5. Align Onshape and MATLAB Track Coordinates

% Match starting coordinates
matlab_track_start = [track.x(1), track.y(1), track.z(1)];

onshape_track_start = [x_on_track(1), ...
                       y_on_track(1), ...
                       z_on_track(1)];

% Calculate coordinate offset
offset = matlab_track_start - onshape_track_start;

% Apply offset to Onshape data
x_on_track = x_on_track + offset(1);
y_on_track = y_on_track + offset(2);
z_on_track = z_on_track + offset(3);


%% 6. Store Onshape Track Coordinates

track.x_onshape = x_on_track;
track.y_onshape = y_on_track;
track.z_onshape = z_on_track;

track.coords_onshape = [x_on_track';
                        y_on_track';
                        z_on_track'];


end