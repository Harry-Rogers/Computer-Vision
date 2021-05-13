clear;close all; clc;

table_a = csvread('a.csv'); %NOISE COORDS
table_b = csvread('b.csv'); %NOISE COORDS
table_x = csvread('x.csv'); %REAL COORDS
table_y = csvread('y.csv'); %REAL COORDS
%plot noisy data with truth and legend
plot(table_a, table_b, "+r");
hold;
plot(table_x, table_y, "xb");
legend('Noisy data','Original', 'Location','northwest')
%Stack data to be x and y coordinates in one array
noise_data = [table_a; table_b];
%Send to kalman tracking to get x,y coords for kalman
[x_kal, y_kal] = kalmanTracking(noise_data);
%Calculate the error
kal_error = [];
noise_error = [];
%For loop over array to calculate error for noisy data and kalman
for K=1: length(x_kal)
    % error = sqrt( (true_x - predit_x)^2 + (true_y - predict_y)^2
    % append to end of array
    kal_error = [kal_error, sqrt((table_x(K) - x_kal(K))^2 + (sqrt((table_y(K) - y_kal(K))^2)))];
    noise_error = [noise_error, sqrt((table_x(K) - table_a(K))^2 + (sqrt((table_y(K) - table_b(K))^2)))];
end
%Plot noisy data, kalman data, truth with legend
figure;
hold on
plot(table_a, table_b, '+r');
plot(x_kal, y_kal, "+g");
plot(table_x, table_y, "xb");
hold off
legend('Noisy data','Kalman Filter','Original', 'Location','northwest')

%average noise error
mean_noise = mean(noise_error);
%standard deviation noise error
std_noise = std(noise_error);
%RMSE noise
RMSE_noise = sqrt((mean(noise_error.^2)));

%average kalman error
mean_kal = mean(kal_error);
%standard deviation kalman error
std_kal = std(kal_error);
%RMSE noise 
RMSE_kal = sqrt((mean(kal_error.^2)));
%Putting into table
averages = [mean_noise; mean_kal];
stds = [std_noise; std_kal];
RMSE = [RMSE_noise; RMSE_kal];
names = {'Noisy data'; 'Kalman tracking'};
%print table
t = table(names, averages, stds, RMSE);
t

%Functions taken from workshop Visual Tracking 2 
%Found here https://learn-eu-central-1-prod-fleet01-xythos.learn.cloudflare.blackboardcdn.com/5eec76bac93d5/3091070?X-Blackboard-Expiration=1620410400000&X-Blackboard-Signature=5u9uHnXDsWRcKvd%2Bbd8ttsGOVq2A8ahMQvcDQ8rpqEk%3D&X-Blackboard-Client-Id=307403&response-cache-control=private%2C%20max-age%3D21600&response-content-disposition=inline%3B%20filename%2A%3DUTF-8%27%27workshop_tracking_2.pdf&response-content-type=application%2Fpdf&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20210507T120000Z&X-Amz-SignedHeaders=host&X-Amz-Expires=21600&X-Amz-Credential=AKIAZH6WM4PL5M5HI5WH%2F20210507%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Signature=4ce2213f43f31f622ecf88cfbaff5cebb04095e6727a9a904c25ccbd1252a009

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
gate = (z - zp)' * inv(S) * (z - zp);
if gate > 9.21 %Gating causes major errors, turn off to get better result or change value to be higher something like 18.42
 xe = x;
 Pe = P;
 return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


xe = x + K * (z - zp); % estimated state
Pe = P - K * S * K'; % estimated covariance
end

function [px, py] = kalmanTracking(z)
% Track a target with a Kalman filter
% z: observation vector
% Return the estimated state position coordinates (px,py)
dt = 0.1; % time interval from brief
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
