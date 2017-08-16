%%%% this piece of code generates the base layer for the 'FS_main' part of the wooden bike saddle 'der FahrStuhl' code
%%% initially developed by Christopher Taudt, 07-2017, CC-BY 3.0


function [basic_contour, base_functions, diff_functions] = FS_base_layer(x,parameters,control_plot,basic_contour_plot,export_decision)

%%% rename all basic parameters for clarity 
length_saddle = parameters(1);
width_max = parameters(2);
width_min = parameters(3);
dilation_horizontal = parameters(4);
dilation_vertical = parameters(5);
radius_1 = parameters(6);
radius_2 = parameters(7);
x_center_1 = parameters(8);
y_center_1 = parameters(9);
x_center_2 = parameters(10);
y_center_2 = parameters(11);
pitch = parameters(12);
x_target = parameters(13);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% CIRCLE / ELLIPSE 1 %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b = radius_1;                                   %% long axis in x-plane
a = radius_1 - dilation_vertical;               %% short axis in y-plane
e = sqrt(a.^2 - b.^2);                          %% excentricity
num_e = e/a;                                    %% numerical excentricity

x_limit_circle_1 = ((2.*(radius_1-dilation_vertical))/pitch)+1;   %% determines the end x-coordinate of the big circle
x(x_limit_circle_1);
limited_x_range = x(1:x_limit_circle_1);

y_circle_1 = zeros(length(width_max),length(x));
y_circle_1_intermed = y_center_1 + sqrt((a'.^2 .- (limited_x_range - a').^2) .* (1-num_e.^2));    %%calculates the actual coordinates of the big circle 
size_circle_1 = length(y_circle_1_intermed);
y_circle_1(:,1:size_circle_1) = y_circle_1_intermed;


diff_y_circle_1 = zeros(length(width_max),length(x));
diff_y_circle_1_intermed =(-((1-num_e.^2).*(limited_x_range-a'))./sqrt((1-num_e^2).*(a'.^2-(limited_x_range-a').^2)));
diff_y_circle_1(:,1:size_circle_1) = diff_y_circle_1_intermed;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% CIRCLE 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_limit_circle_2 = (length_saddle - 2*radius_2)/pitch;
y_circle_2 = zeros(1,length(x));
y_circle_2_intermed = y_center_2 + sqrt(radius_2'.^2-(x(x_limit_circle_2+1:end) .- x_center_2').^2); 
y_circle_2(1,x_limit_circle_2+1:end) = y_circle_2_intermed;
y_circle_2_rep = repmat(y_circle_2,length(radius_1),1);
index_x_center_2 = (x_center_2) / pitch + 1;

diff_y_circle_2 = zeros(1,length(x));
diff_y_circle_2_intermed = -(x(x_limit_circle_2+1:end)-x_center_2)./sqrt(radius_2.^2-(x(x_limit_circle_2+1:end)-x_center_2).^2);
diff_y_circle_2(1,x_limit_circle_2+1:end) = diff_y_circle_2_intermed;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% PARABOLA %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y_offset = radius_2;
index_x_target =  ( (x_target) / pitch) + 1;
x(index_x_target);

y_target = y_circle_1(:,index_x_target);
q_new = (y_target' - y_offset) ./ (x_center_2 - x_target).^2;
y_taille_fit =  q_new' .* (x - (x_center_2')).^2 + y_offset;

diff_y_taille_fit = 2.*q_new'.*(x-x_center_2');


%layer = 1;
basic_contour = [y_circle_1(1, 1:index_x_target) y_taille_fit(1,index_x_target+1:index_x_center_2) y_circle_2_rep(1,index_x_center_2+1:end)];
base_functions = [y_circle_1; y_circle_2; y_taille_fit];
diff_functions = [diff_y_circle_1; diff_y_circle_2; diff_y_taille_fit];

%%% control Plot for evaluation of connection between ellipse and slope
if control_plot
figure('Name','control plot')
hold all;
plot(x,y_circle_1);
plot(x,y_circle_2);
plot(x_target,y_target,"r");
plot(x,y_taille_fit);
%%plot(x,y_taille);x
grid on;

endif


%%% Plot of the basic shpe of the saddle if set to true
if basic_contour_plot
figure('Name','Basic Contour')
hold all;
plot(x,basic_contour);
plot(x,-basic_contour);
axis equal;
%ylim([-100 100]);
grid on;
endif

%%% EXPORT of one single layer for design purposes if set to true
if export_decision
exp_mat_minus = ([x', -basic_contour'] * 100);
exp_mat = ([x', basic_contour'] * 100);
reverse_exp_mat = flipud(exp_mat);
export_matrix = [exp_mat_minus',reverse_exp_mat'];
export_matrix_text =sprintf("%d,%d ", export_matrix);
svg_export(export_matrix_text,"base_layer",true);  
endif
  
  
endfunction
  
  
  