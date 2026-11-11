function plot_all_offsets(track, inner, offset_geometry, outer)
% PLOT_ALL_OFFSETS
% Displays the original track, inner and outer offset curves,
% and their upper surfaces.

figure;
hold on;
axis equal;
grid on;

plot3(track.coords(1,:), track.coords(2,:), track.coords(3,:), 'k', 'LineWidth', 2)

plot3(inner.offset_track_inner(1,:), inner.offset_track_inner(2,:), inner.offset_track_inner(3,:), 'b-', 'LineWidth', 2)
plot3(outer.offset_outer_new(1,:), outer.offset_outer_new(2,:), outer.offset_outer_new(3,:), 'r-', 'LineWidth', 2)

plot3(inner.offset_track_inner2(1,:), inner.offset_track_inner2(2,:), inner.offset_track_inner2(3,:), 'b-', 'LineWidth', 2)
plot3(outer.offset_outer_new2(1,:), outer.offset_outer_new2(2,:), outer.offset_outer_new2(3,:), 'r-', 'LineWidth', 2)

plot3(offset_geometry.track_upper(1,:), offset_geometry.track_upper(2,:), offset_geometry.track_upper(3,:), 'k', 'LineWidth', 2)
plot3(inner.offset_track_inner_upper(1,:), inner.offset_track_inner_upper(2,:), inner.offset_track_inner_upper(3,:), 'b-', 'LineWidth', 2)
plot3(outer.offset_track_outer_upper(1,:), outer.offset_track_outer_upper(2,:), outer.offset_track_outer_upper(3,:), 'r-', 'LineWidth', 2)

view(3);

end