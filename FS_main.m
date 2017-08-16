%%%% this piece of code generates data to cut layers for the wooden bike saddle 'der FahrStuhl' on a laser cutter
%%%% structure is
%%%% -->main (controls everything)
%%%%    ->base_layer (generates the shape of the saddle)
%%%%    ->layer_set (generates the whole layerset with necessary reductions in height for 3D shape)
%%%%    ->special_layers (generates a number of shorter, modified layers; is optional)
%%%%    ->export_container (shapes data and does the actual export in SVG file format)

%%% initially developed by Christopher Taudt, 07-2017, CC-BY 3.0

clear all; clf;
close all;

%pkg load optim

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% NAMES & FOLDERS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% PARAMETERS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% control,parameters
plot_all_layers = 1;
export_all_layers = 0;


%%    definition of dimensions (units are 'mm')
length_saddle = 275;
width_max = 145;                %%% width where you will sit
width_min = 40;                 %%% width at the front end (towards driving direction)
dilation_horizontal = 0;        %%% dilation for ellipse only
dilation_vertical = 10;         %%% dilation for ellipse only
radius_1 = width_max/2;
radius_2 = width_min/2;
layer_thickness = 2;
number_of_layers = 14;
number_of_normal_layers = 11;
number_of_reduced_layers = 2;
layer_offset = 2;

%%%   placement of the elements in the coordinate system
%%%   Ellipse aka the large circle
x_center_1 = radius_1 - dilation_vertical;
y_center_1 = 0;

%%% small circle
x_center_2 = length_saddle - radius_2;
y_center_2 = 0;

pitch = .1;                     %%% equals the resolution
x_target = 87;                  %%% is the point where the parabola and the big circle intersect; 
%%%% simple solution: determine fixed point and let parabola intersect (x_target); has to be adapted by hand
%%%% better solution: determine derivative at fixed point and fit parabola to circle-> gets smoother

%%% combines all important parameters into one name
basic_parameters = [length_saddle, width_max, width_min,dilation_horizontal,dilation_vertical,radius_1,radius_2,x_center_1,y_center_1,x_center_2,y_center_2,pitch,x_target];
x = 0:pitch:length_saddle;      %%% sets the x-scale for all following calculations


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% CALCULATION OF THE ACTUAL LAYERS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[base_layer, base_functions, diff_functions] = FS_base_layer(x,basic_parameters,0,0,0);
[x_layers, y_layers] = FS_layer_set(base_functions,diff_functions,x,basic_parameters,number_of_layers,layer_thickness,0);
[x_layers_shorter, y_layers_shorter] = FS_short_layers(x_layers,y_layers,y_center_2,number_of_normal_layers,number_of_reduced_layers,layer_offset,0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% PLOT OF ALL LAYERS %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plot_all_layers
figure('Name', 'complete saddle')
hold all;
plot(x',base_layer);
plot(x',-base_layer);
plot(x_layers(1:11,:)',y_layers(1:11,:)')
plot(x_layers(1:11,:)',-y_layers(1:11,:)')

plot(x_layers_shorter',y_layers_shorter')
plot(x_layers_shorter',-y_layers_shorter')
grid on;
axis equal;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% EXPORT OF ALL LAYERS %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if export_all_layers

%%% copy shorter layers back to the matrix of all layers
x_layers(13,:) = x_layers_shorter(1,:);
y_layers(13,:) = y_layers_shorter(1,:);

x_layers(14,:) = x_layers_shorter(2,:);
y_layers(14,:) = y_layers_shorter(2,:);


%%% shaping of calculated contours for export
x_layers_single = ( x_layers'(:)*100 )';
y_layers_single = ( y_layers'(:)*100 )';

x_layers_single_shaped = reshape(x_layers_single,1,length(x),[]);
y_layers_single_shaped = reshape(y_layers_single,1,length(x),[]);

multilayer_data_minus = [x_layers_single_shaped;-y_layers_single_shaped];
multilayer_data = [x_layers_single_shaped; y_layers_single_shaped];
reverse_multilayer_data = fliplr(multilayer_data);

%% actual export happens here
multilayer_export_matrix = zeros(2,length(x)*2,number_of_layers);

for w = 1:number_of_layers
exp_mat_index = (w-1)*2 + 1;
multilayer_export_matrix(:,:,w) =  [multilayer_data_minus(:,:,w),reverse_multilayer_data(:,:,w)];
export_name = sprintf("multilayer_export_%i",w);
multilayer_export_matrix_text = sprintf("%d,%d ", multilayer_export_matrix(:,:,w));
svg_export(multilayer_export_matrix_text,export_name,true);
endfor

end
