function [inner, offset_geometry] = generate_inner_offsets(track_data, flap)
% GENERATE_INNER_OFFSETS
% Calculates the geometric offset directions and generates inner
% offset curves around the 3D track.
%
% INPUT:
%   track_data - Structure containing MATLAB track coordinates
%   flap       - Structure containing wing flapping coordinates
%
% OUTPUT:
%   inner - Structure containing:
%       .offset_track_inner
%       .offset_track_inner_upper
%       .offset_track_inner2
%       .offset_distance
%       .offset_distance2
%
%   offset_geometry - Structure containing:
%       .track
%       .track_grad
%       .wing_flap_2D_grad
%       .pin_axis
%       .offset_dir
%       .track_upper
%       .corner_pairs


%% 1. Define Track Coordinates

track = track_data.coords;

x_track = track_data.x;
y_track = track_data.y;
z_track = track_data.z;


%% 2. Calculate Tangent to Track

track_grad = zeros(size(track));

for i = 1:length(x_track)

    if i == length(x_track)
        j = 1;          % Wrap back to start
    else
        j = i + 1;
    end

    track_grad(:,i) = track(:,j) - track(:,i);

    % Normalise
    track_grad(:,i) = track_grad(:,i) / norm(track_grad(:,i));

end


%% 3. Calculate Tangent to Flap

wing_flap_2D = [flap.y; flap.z];

wing_flap_2D_grad = zeros(size(wing_flap_2D));

for i = 1:length(flap.y)-1

    wing_flap_2D_grad(:,i) = ...
        wing_flap_2D(:,i+1) - wing_flap_2D(:,i);

    wing_flap_2D_grad(:,i) = ...
        wing_flap_2D_grad(:,i) / norm(wing_flap_2D_grad(:,i));

end

wing_flap_2D_grad(:,end) = wing_flap_2D_grad(:,1);


%% 4. Fix Tangent Vector Flipping

for i = 2:length(flap.y)-1

    if dot(wing_flap_2D_grad(:,i), ...
           wing_flap_2D_grad(:,i-1)) < 0

        wing_flap_2D_grad(:,i) = -wing_flap_2D_grad(:,i);

    end

end


%% 5. Calculate Pin Axis

% Pin axis is perpendicular to flap tangent [a b] -> [b -a]

pin_axis_2D = [wing_flap_2D_grad(2,:);
               -wing_flap_2D_grad(1,:)];

pin_axis = [zeros(1,size(pin_axis_2D,2));
            pin_axis_2D];

pin_axis = pin_axis ./ vecnorm(pin_axis,2,1);

% Ensure consistent pin axis direction
for i = 2:size(pin_axis,2)

    if dot(pin_axis(:,i),pin_axis(:,i-1)) < 0
        pin_axis(:,i) = -pin_axis(:,i);
    end

end

% Check pin axis angle
atan2d(pin_axis(2,:), pin_axis(3,:));


%% 6. Calculate Offset Direction

% Cross product gives plane perpendicular to both vectors
offset_dir = cross(pin_axis, track_grad);

offset_dir = offset_dir ./ vecnorm(offset_dir,2,1);

% Make offset direction consistently point inward
centre = mean(track,2);

for i = 1:size(track,2)

    to_centre = centre - track(:,i);

    if dot(offset_dir(:,i), to_centre) < 0
        offset_dir(:,i) = -offset_dir(:,i);
    end

end


%% 7. Generate Upper Track

track_upper = track + 0.007*pin_axis;


%% 8. Generate Inner Offset Curve (1.25 mm)

offset_distance = 0.00125;

offset_track_inner = track + offset_distance*offset_dir;

offset_track_inner_upper = offset_track_inner + 0.007*pin_axis;


%% 9. Delete Points Too Close to Original Track

tol = 1e-10;

% Track points to delete
delete_idx = false(1, size(track,2));

% Loop through every offset point
for i = 1:size(offset_track_inner,2)

    % Compare against every track point
    for j = 1:size(track,2)

        track_point = track(:,j);

        % Distance between the two points
        distance = norm(track(:,j) - offset_track_inner(:,i));

        % Delete if distance < offset
        if distance < (offset_distance - tol)

            delete_idx(i) = true;

        end

    end

end

% Delete marked points
offset_track_inner(:,delete_idx) = [];

offset_track_inner(:,end) = [];   % Delete last point to allow loft in Onshape


%% 10. Generate Inner Offset Curve (2.25 mm)

offset_distance2 = 0.00225;

offset_track_inner2 = track + offset_distance2*offset_dir;


%% 11. Delete Points Too Close to Original Track

tol = 1e-10;

% Track points to delete
delete_idx2 = false(1, size(track,2));

% Loop through every offset point
for i = 1:size(offset_track_inner2,2)

    % Compare against every track point
    for j = 1:size(track,2)

        track_point = track(:,j);

        % Distance between the two points
        distance2 = norm(track(:,j) - offset_track_inner2(:,i));

        % Delete if distance < offset
        if distance2 < (offset_distance2 - tol)

            delete_idx2(i) = true;

        end

    end

end

% Delete marked points
offset_track_inner2(:,delete_idx2) = [];

% Delete points to allow loft in Onshape
offset_track_inner2(:,end-8:end) = [];
offset_track_inner2(:,1:8) = [];


%% 12. Store Results

inner.offset_track_inner = offset_track_inner;
inner.offset_track_inner_upper = offset_track_inner_upper;
inner.offset_track_inner2 = offset_track_inner2;

inner.offset_distance = offset_distance;
inner.offset_distance2 = offset_distance2;

% Store geometric information for outer offset generation
offset_geometry.track = track;
offset_geometry.track_grad = track_grad;
offset_geometry.wing_flap_2D_grad = wing_flap_2D_grad;
offset_geometry.pin_axis = pin_axis;
offset_geometry.offset_dir = offset_dir;
offset_geometry.track_upper = track_upper;

end