function outer = generate_outer_offsets(track_data, offset_geometry, inner)
% GENERATE_OUTER_OFFSETS
% Generates outer offset curves around the 3D track and joins gaps at
% corners using line intersections.
%
% INPUT:
%   track_data      - Structure containing MATLAB track coordinates
%   offset_geometry - Structure containing track offset directions
%   inner           - Structure containing inner offset distances
%
% OUTPUT:
%   outer - Structure containing:
%       .offset_track_outer
%       .offset_outer_new
%       .offset_track_outer_upper
%       .offset_track_outer2
%       .offset_outer_new2


%% 1. Retrieve Track Geometry

track = offset_geometry.track;
offset_dir = offset_geometry.offset_dir;
pin_axis = offset_geometry.pin_axis;

x_track = track_data.x;
y_track = track_data.y;
z_track = track_data.z;


%% 2. Define Corner Pairs

% Manually identified gaps from the original track sampling
corner_pairs = [47,  48;
                99,  100;
                126, 127;
                142, 143;
                174, 1];


%% 3. Generate Outer Offset Curve (1.25 mm)

offset_distance = inner.offset_distance;

offset_track_outer = track - offset_distance*offset_dir;

offset_track_outer_upper = offset_track_outer + 0.007*pin_axis;


%% 4. Calculate Corner Intersections

corner_points = zeros(3,size(corner_pairs,1));

for k = 1:size(corner_pairs,1)

    i1 = corner_pairs(k,1);
    i2 = corner_pairs(k,2);

    % Previous and next points
    if i2 == 1
        i_prev = i1 - 1;
        i_next = 2;
    else
        i_prev = i1 - 1;
        i_next = i2 + 1;
    end

    % Incoming line
    P1 = offset_track_outer(1:2,i_prev);
    P2 = offset_track_outer(1:2,i1);
    d1 = P2 - P1;

    % Outgoing line
    P3 = offset_track_outer(1:2,i2);
    P4 = offset_track_outer(1:2,i_next);
    d2 = P4 - P3;

    % Intersection
    A = [d1, -d2];
    b = P3 - P1;

    ts = A\b;

    intersection_xy = P1 + ts(1)*d1;

    % Average Z
    z_corner = ...
        (offset_track_outer(3,i1) + ...
         offset_track_outer(3,i2))/2;

    corner_points(:,k) = ...
        [intersection_xy;
         z_corner];

end


%% 5. Build Corrected Outer Track (1.25 mm)

offset_outer_new = [];

for i = 1:size(offset_track_outer,2)

    % Add original point
    offset_outer_new(:,end+1) = offset_track_outer(:,i);

    % Add corner point after i1
    for k = 1:size(corner_pairs,1)

        i1 = corner_pairs(k,1);
        i2 = corner_pairs(k,2);

        % Don't insert wrap-around corner yet
        if i == i1 && i2 ~= 1
            offset_outer_new(:,end+1) = corner_points(:,k);
        end

    end

end

% Add wrap-around corner at the end
for k = 1:size(corner_pairs,1)

    if corner_pairs(k,2) == 1
        offset_outer_new(:,end+1) = corner_points(:,k);
    end

end


%% 6. Generate Outer Offset Curve (2.25 mm)

offset_distance2 = inner.offset_distance2;

offset_track_outer2 = track - offset_distance2*offset_dir;


%% 7. Calculate Corner Intersections

corner_points = zeros(3,size(corner_pairs,1));

for k = 1:size(corner_pairs,1)

    i1 = corner_pairs(k,1);
    i2 = corner_pairs(k,2);

    % Previous and next points
    if i2 == 1
        i_prev = i1 - 1;
        i_next = 2;
    else
        i_prev = i1 - 1;
        i_next = i2 + 1;
    end

    % Incoming line
    P1 = offset_track_outer2(1:2,i_prev);
    P2 = offset_track_outer2(1:2,i1);
    d1 = P2 - P1;

    % Outgoing line
    P3 = offset_track_outer2(1:2,i2);
    P4 = offset_track_outer2(1:2,i_next);
    d2 = P4 - P3;

    % Intersection
    A = [d1, -d2];
    b = P3 - P1;

    ts = A\b;

    intersection_xy = P1 + ts(1)*d1;

    % Average Z
    z_corner = ...
        (offset_track_outer2(3,i1) + ...
         offset_track_outer2(3,i2))/2;

    corner_points(:,k) = ...
        [intersection_xy;
         z_corner];

end


%% 8. Build Corrected Outer Track (2.25 mm)

offset_outer_new2 = [];

for i = 1:size(offset_track_outer2,2)

    % Add original point
    offset_outer_new2(:,end+1) = offset_track_outer2(:,i);

    % Add corner point after i1
    for k = 1:size(corner_pairs,1)

        i1 = corner_pairs(k,1);
        i2 = corner_pairs(k,2);

        % Don't insert wrap-around corner yet
        if i == i1 && i2 ~= 1
            offset_outer_new2(:,end+1) = corner_points(:,k);
        end

    end

end

% Add wrap-around corner at the end
for k = 1:size(corner_pairs,1)

    if corner_pairs(k,2) == 1
        offset_outer_new2(:,end+1) = corner_points(:,k);
    end

end


%% 9. Store Results

outer.offset_track_outer = offset_track_outer;
outer.offset_track_outer_upper = offset_track_outer_upper;

outer.offset_outer_new = offset_outer_new;

outer.offset_track_outer2 = offset_track_outer2;
outer.offset_outer_new2 = offset_outer_new2;

outer.corner_pairs = corner_pairs;

end