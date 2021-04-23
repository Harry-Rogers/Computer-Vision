clear;close all; clc;

table_a = csvread('a.csv'); %NOISE COORDS
table_b = csvread('b.csv'); %NOISE COORDS
table_x = csvread('x.csv'); %REAL COORDS
table_y = csvread('y.csv'); %REAL COORDS
fprintf("Tables:");

table_a
table_b
table_x
table_y

table_a_mean = mean(table_a);
table_b_mean = mean(table_b);
table_x_mean = mean(table_x);
table_y_mean = mean(table_y);
fprintf('Table A mean %s\n', table_a_mean);
fprintf('Table B mean %s\n', table_b_mean);
fprintf('Table X mean %s\n', table_x_mean);
fprintf('Table Y mean %s\n', table_y_mean);

fprintf('\n');

table_a_std = std(table_a);
table_b_std = std(table_b);
table_x_std = std(table_x);
table_y_std = std(table_y);

fprintf('Table A std %s\n', table_a_mean);
fprintf('Table B std %s\n', table_b_mean);
fprintf('Table X std %s\n', table_x_mean);
fprintf('Table Y std %s\n', table_y_mean);

fprintf('\n');

nx = table_a - table_x;
ny = table_b - table_y;

mean_nx = mean(nx);
mean_ny = mean(ny);

fprintf('Mean noise in x %s\n', mean_nx);
fprintf('Mean noise in y %s\n', mean_ny);
fprintf('\n');

std_nx = std(nx);
std_ny = std(ny);

fprintf('STD noise in x %s\n', std_nx);
fprintf('STD noise in y %s\n', std_ny);
fprintf('\n');




track_a = kalmanTracking(table_a);
track_b = kalmanTracking(table_b);

n_track_x = track_a - table_x;
n_track_y = track_b - table_y;



X_coord = square(n_track_x);
Y_coord = square(n_track_y);

error = sqrt(X_coord + Y_coord);
std_track_x = std(n_track_x);
std_track_y = std(n_track_y);
fprintf("STD for x coords = %s\n", std_track_x);
fprintf("STD for y coords = %s\n", std_track_y);
fprintf("\n");
mean_track_x = mean(n_track_x);
mean_track_y = mean(n_track_y);
fprintf("Mean for x coords = %s\n", mean_track_x);
fprintf("Mean for y coords = %s\n", mean_track_y);
fprintf("\n");
RMSE = sqrt(immse(error, table_x));
fprintf("RMSE value = %s\n", RMSE);



plot(table_a, table_b, "+r");
hold;
plot(table_x, table_y, "xb");



figure;
plot(track_a, track_b, "+r");
hold;
plot(table_x, table_y, "xb");

%initial_x = table_a(1,1);

%kalmanFilter = configureKalmanFilter('ConstantVelocity', initial_x, );

%predict = kalmanPredict(table_a, );
%update = kalmanUpdate();
%track = kalmanTracking();

% rmse = sqrt(immse(scores, dates));

function [xp, Pp] = kalmanPredict(x, P, F, Q)
% Prediction step of Kalman filter.
% x: state vector
% P: covariance matrix of x
% F: matrix of motion model
% Q: matrix of motion noise
% Return predicted state vector xp and covariance Pp
xp = F * x; % predict state
Pp = F * P * F' + Q; % predict state covariance
end

function [xe, Pe] = kalmanUpdate(x, P, H, R, z)
% Update step of Kalman filter.
% x: state vector
% P: covariance matrix of x
% H: matrix of observation model
% R: matrix of observation noise
% z: observation vector
% Return estimated state vector xe and covariance Pe
S = H * P * H' + R; % innovation covariance
K = P * H' * inv(S); % Kalman gain
zp = H * x; % predicted observation
%%%%%%%%% UNCOMMENT FOR VALIDATION GATING %%%%%%%%%%
%gate = (z - zp)' * inv(S) * (z - zp);
%if gate > 9.21
% warning('Observation outside validation gate');
% xe = x;
% Pe = P;
% return
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xe = x + K * (z - zp); % estimated state
Pe = P - K * S * K'; % estimated covariance
end

function [px, py] = kalmanTracking(z)
% Track a target with a Kalman filter
% z: observation vector
% Return the estimated state position coordinates (px,py)
dt = 0.033; % time interval
N = length(z); % number of samples
F = [1 dt 0 0; 0 1 0 0; 0 0 1 dt; 0 0 0 1]; % CV motion model
Q = [0.16 0 0 0; 
    0 0.36 0 0; 
    0 0 0.16 0; 
    0 0 0 0.36]; %Taken from brief
H = [1 0 0 0; 0 0 1 0]; % Cartesian observation model
R = [0.25 0;
    0 0.25]; % observation noise taken from beif
x = [0 0 0 0]'; % initial state
P = Q; % initial state covariance
s = zeros(4,N);
for i = 1 : N
 [xp Pp] = kalmanPredict(x, P, F, Q);
 [x P] = kalmanUpdate(xp, Pp, H, R, z(:,i));
 s(:,i) = x; % save current state
end
px = s(1,:); % NOTE: s(2, :) and s(4, :), not considered here,
py = s(3,:); % contain the velocities on x and y respectively
end