%%%% this piece of code generates the complete layer set for the 'FS_main' part of the wooden bike saddle 'der FahrStuhl' code
%%% initially developed by Christopher Taudt, 07-2017, CC-BY 3.0


function [x_layers, y_layers] = FS_layer_set(base_functions,diff_functions,x,parameters,number_of_layers,layer_thickness,layerset_contour_plot)

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

y_circle_1 = base_functions(1,:);
y_circle_2 = base_functions(2,:);
y_taille_fit = base_functions(3,:);

diff_y_circle_1 = diff_functions(1,:);
diff_y_circle_2 = diff_functions(2,:);
diff_y_taille_fit = diff_functions(3,:);

index_x_target =  ( (x_target) / pitch) + 1;
index_x_center_2 = (x_center_2) / pitch + 1;

%%%% function definition of the reduction function
function [new_curve] = new_slope(m,x,y,number_of_layer,layer_thickness)

parameters = [ 26.7952,-29.0394,-8.7896]; %%%empirische Werte die an Muster entwickelt wurden

y_new(number_of_layer) = (number_of_layer-1) .* layer_thickness;
x_new(number_of_layer) = log(((y_new(number_of_layer))-parameters(1))./parameters(2)).*(parameters(3));

%%% calcuation of the tangent function 
t = y - ( m .* x);
tangent = m .* (x) + t;

%%% calculation of the orthogonal of the tangent function
m2 = -(1 ./ m);
t2 = y - m2 .* x;
orthogonal_tangent = m2 .*x  + t2;

%%% calculation of the intersection with the orthogonal function and the baseline
x_zero = -t2 ./ m2;

%%% calculation of the resulting triangle
a = y;
b = x_zero - x;
c = sqrt(a.^2 + b.^2);

%%% calculation of the reduced triangle
reduction = x_new(number_of_layer);
c_new = c' - (reduction);
phi = asin(y./c);

y_coord_new = sin(phi).*c_new';
b_neu = cos(phi).*c_new';
x_coord_new = (y_coord_new-t2)./m2;

new_curve = [x_coord_new;y_coord_new];
endfunction

NoL_range = 1:number_of_layers;

circle_1_reduced = new_slope(diff_y_circle_1,x,y_circle_1,NoL_range,layer_thickness);
taille_reduced = new_slope(diff_y_taille_fit,x,y_taille_fit,NoL_range,layer_thickness);
circle_2_reduced = new_slope(diff_y_circle_2,x,y_circle_2,NoL_range,layer_thickness);

%%% make profile closed at the beginning!!!
circle_1_reduced(1:number_of_layers,1) = circle_1_reduced(1:number_of_layers,2);
circle_1_reduced(number_of_layers+1:end,1) = 0;

%%% make profile closed at the end!!
circle_2_reduced(1:number_of_layers,end) = circle_2_reduced(1:number_of_layers,end-1);
circle_2_reduced(number_of_layers+1:end,end) = 0;

%%% Calculation of the  actual reduced layers
x_layers = [circle_1_reduced(1:number_of_layers,1:index_x_target), taille_reduced(1:number_of_layers,index_x_target+1:index_x_center_2), circle_2_reduced(1:number_of_layers,index_x_center_2+1:end)];
y_layers = [circle_1_reduced(number_of_layers+1:end,1:index_x_target), taille_reduced(number_of_layers+1:end,index_x_target+1:index_x_center_2), circle_2_reduced(number_of_layers+1:end,index_x_center_2+1:end)];

%%% exclude some NaN values due to zero diff and errors which occur during export 
is_NAN = isnan(y_layers);
[NAN_row, NAN_col] = find(is_NAN);
y_layers(NAN_row,NAN_col) = y_layers(NAN_row,NAN_col-1); 
x_layers(NAN_row,NAN_col) = x_layers(NAN_row,NAN_col-1);


%%% Plot of the complete calculated layer set of the saddle if set to true
if layerset_contour_plot
figure('Name','Layerset')
hold all;
plot(x_layers',y_layers');
plot(x_layers',-y_layers');
axis equal;
%ylim([-100 100]);
grid on;
endif
  
endfunction
  