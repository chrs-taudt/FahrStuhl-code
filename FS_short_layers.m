%%%% this piece of code generates a set of smaller (shorter) layers for the 'FS_main' part of the wooden bike saddle 'der FahrStuhl' code
%%% initially developed by Christopher Taudt, 08-2017, CC-BY 3.0


function [x_layers_shorter, y_layers_shorter] = FS_short_layers(x_layers,y_layers,y_center_2,number_of_normal_layers,number_of_reduced_layers,layer_offset,short_layers_plot);

reduced_start_layer = number_of_normal_layers + layer_offset;
layer_range = reduced_start_layer:(reduced_start_layer+number_of_reduced_layers-1);

x_distance_index = length(x_layers(reduced_start_layer,:));

for t=1:number_of_reduced_layers

%%%% these values are determined empiricaly
%% determines the new length of the layer
reduced_x_distance_index = round( 1.6*((x_distance_index * t) ./ (3.7 * t) ) );
%%% positions the new circle relative to the rest of the curve
reduction_factor = 5.5*t^.001;
center_reduced = x_layers(layer_range(1,t),reduced_x_distance_index)-reduction_factor;
radius_reduced = y_layers(layer_range(1,t),reduced_x_distance_index);
%%% use an ellipse instead of a circle here will probably lead to a smoother outline...
reduced_y_circle(t,:) = y_center_2 + sqrt(radius_reduced'.^2-(x_layers(layer_range(1,t),:) .- center_reduced').^2); 
index_new_layer = max(find(imag(reduced_y_circle(t,:))==0));
    
  %%% the vector for the new layer will be too short as we intended to shorten the length; so the pitch for the new circle has to be refined to adjust the vector length accordingly if we want to use the functions for export and display of the other layers
  %%% modification of x_range

  %%% remaining length of layer
empty_vector_length = (length(x_layers) - (reduced_x_distance_index));
distance_2 = x_layers(layer_range(1,t),index_new_layer+1) - center_reduced;
new_pitch_2 = (radius_reduced-reduction_factor) / empty_vector_length ;

x_fine_2 = x_layers(layer_range(1,t),1):new_pitch_2:x_layers(layer_range(1,t),end);
partial_x_fine_2 = x_layers(layer_range(1,t),1):new_pitch_2:x_layers(layer_range(1,t),reduced_x_distance_index);
reduced_x_distance_index_fine_2 = length(partial_x_fine_2); 

reduced_y_circle_fine_2 = y_center_2 + sqrt(radius_reduced'.^2-(x_fine_2 .- center_reduced').^2); 
index_new_layer_fine_2 = max(find(imag(reduced_y_circle_fine_2)==0));
control_distance = x_fine_2(index_new_layer_fine_2) - x_fine_2(reduced_x_distance_index_fine_2);
index_new_layer_fine_2 - reduced_x_distance_index_fine_2;

y_layers_shorter(t,:) = [y_layers(layer_range(1,t),1:reduced_x_distance_index-1), reduced_y_circle_fine_2(reduced_x_distance_index_fine_2:index_new_layer_fine_2)] ;
%%% correct last value to be zero
y_layers_shorter(t,end) = 0;
x_layers_shorter(t,:) = [x_layers(layer_range(1,t),1:reduced_x_distance_index-1), x_fine_2(reduced_x_distance_index_fine_2:index_new_layer_fine_2)] ;
end

%%% Plot of the c shorter layer set of the saddle if set to true
if short_layers_plot
figure('Name','short Layerset')
hold all;
plot(x_layers_shorter',y_layers_shorter');
plot(x_layers_shorter',-y_layers_shorter');
axis equal;
grid on;
endif



end