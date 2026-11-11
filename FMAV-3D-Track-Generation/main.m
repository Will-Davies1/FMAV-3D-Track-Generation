%% FMAV Wing Mechanism - Main Script
% Generates the wing flapping motion, maps the wing twist angle,
% develops the 3D track, and calculates the inner and outer offset curves.

clear;
clc;
close all;

%% Project Setup

% Identify the project directory and required folders
project_dir = fileparts(mfilename('fullpath'));

data_folder = fullfile(project_dir, 'data');
src_folder = fullfile(project_dir, 'src');
plotting_folder = fullfile(project_dir, 'plotting');

% Add function folders to the MATLAB path
addpath(src_folder);
addpath(plotting_folder);

%% 1. Generate Flapping Input

% Generate the wing flapping motion and compare it with the Onshape data
flap = generate_flapping_input(data_folder);

%% 2. Map Wing Twist Angle

% Map the wing twist angle against the flapping motion
theta = map_theta(flap);

%% 3. Generate 3D Track

% Generate the MATLAB track and compare it with the Onshape track
track = generate_track(flap, theta, data_folder);

%% 4. Generate Inner Offset Curves

% Calculate the inner offset curves and supporting geometry
[inner, offset_geometry] = generate_inner_offsets(track, flap);

%% 5. Generate Outer Offset Curves

% Calculate the outer offset curves and join the corner intersections
outer = generate_outer_offsets(track, offset_geometry, inner);

%% 6. Plot Results

% Compare MATLAB and Onshape flapping motion
plot_flapping_comparison(flap);

% Plot linear and nonlinear wing twist mapping
plot_theta_mapping(theta);

% Compare MATLAB and Onshape track geometry
plot_track_comparison(track);

% Plot complete track and offset geometry
plot_all_offsets(track, inner, offset_geometry, outer);